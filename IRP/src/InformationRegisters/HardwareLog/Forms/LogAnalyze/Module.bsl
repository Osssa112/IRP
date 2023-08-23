// @strict-types

&AtClient
Procedure Update(Command)
	UpdateAtServer();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Items.GroupLogSettings.Visible = Parameters.OpenAsLog;
	TimeZone = CommonFunctionsServer.GetStandardTimeOffset();
	//@skip-check property-return-type
	HardwareArray = Parameters.Hardware; // Array Of CatalogRef.Hardware
	Hardware.LoadValues(HardwareArray);
	Period.Variant = StandardPeriodVariant.Today;
	Workstation = SessionParametersServer.GetSessionParameter("Workstation"); // CatalogRef.Workstations
	FiscalPrinterFind = HardwareServer.GetWorkstationHardwareByEquipmentType(Workstation, Enums.EquipmentTypes.FiscalPrinter);
	If FiscalPrinterFind.Count() = 1 Then
		FiscalPrinter = FiscalPrinterFind[0];
	EndIf;
	UpdateAtServer();
EndProcedure

&AtServer
Procedure UpdateAtServer()
	TransactionList.Clear();
	SkipMethods = GetListMethodForSkip();

	Query = New Query;
	Query.Text =
		"SELECT
		|	DATEADD(HardwareLog.Period, HOUR, &TimeZone) AS Period,
		|	HardwareLog.Hardware,
		|	HardwareLog.Method,
		|	HardwareLog.Data,
		|	HardwareLog.Result
		|FROM
		|	InformationRegister.HardwareLog AS HardwareLog
		|WHERE
		|	HardwareLog.Hardware IN (&Hardware)
		|	AND DATEADD(HardwareLog.Period, HOUR, &TimeZone) BETWEEN &StartDate AND &EndDate
		|	AND NOT HardwareLog.Method IN (&SkipMethods)
		|	AND NOT HardwareLog.Request
		|
		|ORDER BY
		|	HardwareLog.Date";

	Query.SetParameter("StartDate", Period.StartDate);
	Query.SetParameter("EndDate", Period.EndDate);
	Query.SetParameter("SkipMethods", SkipMethods);
	Query.SetParameter("Hardware", Hardware);
	Query.SetParameter("TimeZone", TimeZone);
	QueryResult = Query.Execute();

	SelectionDetailRecords = QueryResult.Select();

	While SelectionDetailRecords.Next() Do
		NewRow = TransactionList.Add();
		FillPropertyValues(NewRow, SelectionDetailRecords);

		If NewRow.Method = "PayByPaymentCard"
			OR NewRow.Method = "ReturnPaymentByPaymentCard"
			OR NewRow.Method = "CancelPaymentByPaymentCard"
			OR NewRow.Method = "Settlement" Then
				Payments = CommonFunctionsServer.DeserializeJSON(NewRow.Data); // See EquipmentAcquiringAPIClient.SettlementSettings
				NewRow.PrintInfo = Payments.Out.Slip;
		EndIf;
	EndDo;

EndProcedure

&AtClient
Async Procedure PrintData(Command)
	CurrentRow = Items.TransactionList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	CRS = New Structure;
	CRS.Insert("FiscalPrinter", FiscalPrinter);

	PaymentSettings = CommonFunctionsServer.DeserializeJSON(CurrentRow.Data); // See EquipmentAcquiringAPIClient.SettlementSettings
	DocumentPackage = EquipmentFiscalPrinterAPIClient.DocumentPackage();
	DocumentPackage.TextString = StrSplit(PaymentSettings.Out.Slip, Chars.LF + Chars.CR);
	PrintResult = Await EquipmentFiscalPrinterClient.PrintTextDocument(CRS, DocumentPackage); // See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings
	If Not PrintResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(PrintResult.Info.Error);
	EndIf;
EndProcedure

&AtClient
Procedure TransactionListOnActivateRow(Item)
	CurrentRow = Items.TransactionList.CurrentData;
	If CurrentRow = Undefined Then
		Items.TransactionListPrintData.Enabled = False;
		Return;
	EndIf;
	Items.TransactionListPrintData.Enabled = Not IsBlankString(CurrentRow.PrintInfo);
EndProcedure

&AtServer
Function GetListMethodForSkip()
	SkipMethods = New Array; // Array Of String
	SkipMethods.Add("Open");
	SkipMethods.Add("Close");
	SkipMethods.Add("SetParameter");
	Return SkipMethods;
EndFunction
