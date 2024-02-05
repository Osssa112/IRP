&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatExpenseAndRevenueTypesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		ThisObject.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;

	If Parameters.Property("FormTitle") Then
		ThisObject.Title = Parameters.FormTitle;
		ThisObject.AutoTitle = False;
	EndIf;
	
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion