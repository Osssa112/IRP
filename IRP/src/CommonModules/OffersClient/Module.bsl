Procedure OpenFormPickupSpecialOffers_ForDocument(Object, Form, NotifyEditFinish, AddInfo = Undefined) Export
	OpenFormArgs = OffersClientServer.GetOpenFormArgsPickupSpecialOffers_ForDocument(Object);
	NotifyDescription = New NotifyDescription(NotifyEditFinish, Form, AddInfo);
	OpenForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), , , , , NotifyDescription,
			 FormWindowOpeningMode.LockWholeInterface);
EndProcedure

Procedure SpecialOffersEditFinish_ForDocument(OffersInfo, Object, Form, AddInfo = Undefined) Export
	If OffersInfo = Undefined Then
		Return;
	EndIf;
	If Form.TaxAndOffersCalculated Then
		Form.TaxAndOffersCalculated = False;
	EndIf;
	OffersServer.CalculateOffersAfterSet(Object, OffersInfo);
	
	ViewClient_V2.OffersOnChange(Object, Form);
	
	Form.Modified = True;
	Form.TaxAndOffersCalculated = True;
	
	ExecuteCallback(AddInfo);
EndProcedure

Procedure OpenFormPickupSpecialOffers_ForRow(Object, CurrentRow, Form, NotifyEditFinish, AddInfo = Undefined) Export
	OpenFormArgs = GetOpenFormArgsPickupSpecialOffers_ForRow(Object, CurrentRow);
	OpenForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), Form, , , ,
		New NotifyDescription(NotifyEditFinish, Form, AddInfo), FormWindowOpeningMode.LockWholeInterface);
EndProcedure

Function GetOpenFormArgsPickupSpecialOffers_ForRow(Object, CurrentRow) Export
	OpenArgs = New Structure();
	OpenArgs.Insert("ArrayOfOffers", OffersServer.GetAllActiveOffers_ForRow(Object));
	OpenArgs.Insert("Type", "Offers_ForRow");
	OpenArgs.Insert("ItemListRowKey", CurrentRow.Key);
	OpenArgs.Insert("Object", Object);
	Return OpenArgs;
EndFunction

Procedure SpecialOffersEditFinish_ForRow(OffersInfo, Object, Form, AddInfo = Undefined) Export
	If OffersInfo = Undefined Then
		Return;
	EndIf;
	
	OffersServer.CalculateAndLoadOffers_ForRow(Object, OffersInfo.OffersAddress, OffersInfo.ItemListRowKey);
	
	ViewClient_V2.OffersOnChange(Object, Form);
	
	Form.Modified = True;
	ExecuteCallback(AddInfo);
EndProcedure

Procedure ExecuteCallback(Args)
	If Args <> Undefined And TypeOf(Args) = Type("Structure") And Args.Property("Callback") Then

		Execute StrTemplate("Args.Callback.Module.%1();", Args.Callback.Method);

	EndIf;
EndProcedure
