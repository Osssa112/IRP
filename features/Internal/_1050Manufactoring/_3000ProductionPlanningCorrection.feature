﻿#language: en
@tree
@ProductionPlanningCorrection

Feature: production planning correction

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I open new TestClient session or connect the existing one




Scenario: _3000 preparation (production planning correction)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When change interface localization code for CI
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog Users objects
	When Create chart of characteristic types AddAttributeAndProperty objects
	When Create catalog AddAttributeAndPropertySets objects
	When Create catalog AddAttributeAndPropertyValues objects
	When Create catalog AccessProfiles objects
	When Create catalog AccessGroups objects
	When Create catalog Companies objects (Main company)
	When Create catalog ItemTypes objects (MF)
	When Create catalog Stores objects
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects (MF)
	When Create catalog Countries objects
	When Create catalog Items objects (MF)
	When Create catalog Units objects
	When Create catalog Units objects (MF)
	When Create catalog ItemKeys objects (MF)
	When update ItemKeys
	And Delay 10
	When Create catalog PlanningPeriods objects (MF)
	When Create catalog MFBillOfMaterials objects
	* Update user roles
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I go to line in "List" table
			| 'Description'                 |
			| 'Manager' |
		And I click "Update all user roles" button	
	And Delay 10
	When Create document ProductionPlanning objects
	And I execute 1C:Enterprise script at server
 			| "Documents.ProductionPlanning.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.ProductionPlanning.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ProductionPlanning.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
	* Change localization code for user ABrown
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
				| 'Description'                 |
				| 'Arina Brown (Financier 3)' |
		And I select current line in "List" table
		And I select "Russian" exact value from "Data localization" drop-down list	
		And I select "English" exact value from "Interface localization" drop-down list
		And I click "Save" button
	And I close all client application windows

Scenario: _3003 create Production planning correction statuses 
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I expand current line in "List" table			
	* Create status Created
		And I go to line in "List" table
			| 'Predefined data name'         |
			| 'ProductionPlanningCorrection' |
		And I click the button named "FormCreate"
		And I input "Created" text in "RU" field	
		And I set checkbox "Set by default"
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description' |
			| 'CI'          |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Login'     |
			| 'SBorisova' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click "Save and close" button
	* Create status Approved
		And I go to line in "List" table
			| 'Predefined data name'         |
			| 'ProductionPlanningCorrection' |
		And I click the button named "FormCreate"
		And I input "Approved" text in "RU" field
		And I set checkbox "Posting"
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description' |
			| 'CI'          |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click "Save and close" button

	


Scenario: _3050 create production planning correction and check it movements (quantity)
	// First month
	* Create document
		And In the command interface I select "Manufacturing" "Production planning correction"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Склад производства 05' |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I move to "Productions" tab
		And I move to "Other" tab
		And I click Select button of "Production planning" field
		And I go to line in "List" table
			| 'Number' | 'Planning period' |
			| '1'      | 'First month'    |
		And I activate "Date" field in "List" table
		And I select current line in "List" table
		Then the form attribute named "PlanningPeriod" became equal to "First month"
		And I move to "Productions" tab
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I select current line in "List" table		
		And "Productions" table contains lines
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Current Q' | 'Bill of materials'                  |
			| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' | 'pcs'  | '1,000' | '250,000'   | 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I activate "Q" field in "Productions" table
		And I select current line in "Productions" table
		And I input "260" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I select current line in "List" table
		And I select current line in "Productions" table
		And I click choice button of the attribute named "ProductionsItemKey" in "Productions" table
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table		
		And "Productions" table contains lines
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Current Q' | 'Bill of materials'                  |
			| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Стремянка CLASS PLUS 6 ступенчатая' | 'pcs'  | '1,000' | '100,000'   | 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I go to line in "Productions" table
			| 'Item'                               |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |	
		And I activate "Q" field in "Productions" table
		And I input "90" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And I move to "Other" tab
		And I click the button named "FormPost"
		And I delete "$$NumberProductionPlanningCorrection01$$" variable
		And I delete "$$ProductionPlanningCorrection01$$" variable
		And I delete "$$DateProductionPlanningCorrection01$$" variable
		And I save the value of "Number" field as "$$NumberProductionPlanningCorrection01$$"
		And I save the window as "$$ProductionPlanningCorrection01$$"
		And I save the value of the field named "Date" as "$$DateProductionPlanningCorrection01$$"
		And I close all client application windows
	* Check movements
		Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberProductionPlanningCorrection01$$' |
		And I click "Registrations report" button
		And I select "R7020 Material planning" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection01$$'  | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| 'Document registrations records'      | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| 'Register  "R7020 Material planning"' | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| ''                                    | 'Period'                                 | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| ''                                    | ''                                       | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Production'                              | 'Item key'                                | 'Planning type'   | 'Planning period' | 'Bill of materials'                          |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-150'      | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-100'      | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-50'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-38'       | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | 'Store 02' | 'Копыта на стремянки Класс 30х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'First month'     | '01 Копыта на стремянки Класс 30х20, черный' |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-19,6'     | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'First month'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-10'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Краска порошковая серая 9006'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-10'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Коврик для стремянок Класс, черный'      | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '10'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Краска порошковая серая 9006'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '19,6'      | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'First month'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '50'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '100'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '150'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
		And I select "R7030 Production planning" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection01$$'   | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| 'Document registrations records'       | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| 'Register  "R7030 Production planning"'| ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| ''                                     | 'Period'                                 | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| ''                                     | ''                                       | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Item key'                                | 'Planning type'   | 'Planning period' | 'Production type' | 'Bill of materials'                          |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | 'Store 01' | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'First month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 30х20, черный' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | '-10'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Plan adjustment' | 'First month'     | 'Product'         | 'Стремянка CLASS PLUS 6 ступенчатая'         |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | '10'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Plan adjustment' | 'First month'     | 'Product'         | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
		And I select "T7010 Bill of materials" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection01$$'  | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| 'Document registrations records'      | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| 'Register  "T7010 Bill of materials"' | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| ''                                    | 'Period'                                 | 'Resources'                                  | ''     | ''         | ''           | ''               | 'Dimensions'   | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| ''                                    | ''                                       | 'Bill of materials'                          | 'Unit' | 'Quantity' | 'Basis unit' | 'Basis quantity' | 'Company'      | 'Planning document'      | 'Business unit'         | 'Input ID' | 'Output ID' | 'Unique ID' | 'Surplus store' | 'Writeoff store' | 'Item key'                                | 'Is product' | 'Is semiproduct' | 'Is material' | 'Is service' | 'Planning period' |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '90'       | 'pcs'        | '90'             | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Коврик для стремянок Класс, черный'      | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '180'      | 'pcs'        | '180'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '450'      | 'pcs'        | '450'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '520'      | 'pcs'        | '520'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '900'      | 'pcs'        | '900'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '1 300'    | 'pcs'        | '1 300'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '1 350'    | 'pcs'        | '1 350'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '2 600'    | 'pcs'        | '2 600'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '3 900'    | 'pcs'        | '3 900'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '90'       | 'кг'         | '90'             | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Краска порошковая серая 9006'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '176,4'    | 'кг'         | '176,4'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '180'      | 'кг'         | '180'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '260'      | 'кг'         | '260'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Краска порошковая серая 9006'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '342'      | 'кг'         | '342'            | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | '*'        | ''          | '*'         | ''              | 'Store 02'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '509,6'    | 'кг'         | '509,6'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '520'      | 'кг'         | '520'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '180'      | 'pcs'        | '180'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '520'      | 'pcs'        | '520'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | '01 Копыта на стремянки Класс 30х20, черный' | 'pcs'  | '180'      | 'pcs'        | '180'            | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 30х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | 'Стремянка CLASS PLUS 5 ступенчатая'         | 'pcs'  | '260'      | 'pcs'        | '260'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | ''         | '*'         | '*'         | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Yes'        | 'No'             | 'No'          | 'No'         | 'First month'     |
			| ''                                    | '$$DateProductionPlanningCorrection01$$' | 'Стремянка CLASS PLUS 6 ступенчатая'         | 'pcs'  | '90'       | 'pcs'        | '90'             | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | ''         | '*'         | '*'         | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Yes'        | 'No'             | 'No'          | 'No'         | 'First month'     |
		And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:	
			| 'Register  "R7010 Detailing supplies"' | ''                                       | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        | '' |
			| ''                                     | 'Period'                                 | 'Resources'             | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Dimensions'   | ''                      | ''         | ''                | ''                                        | '' |
			| ''                                     | ''                                       | 'Entry demand quantity' | 'Corrected demand quantity' | 'Needed produce quantity' | 'Produced produce quantity' | 'Reserved produce quantity' | 'Written off produce quantity' | 'Request procurement quantity' | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity' | 'Confirmed purchase quantity' | 'Company'      | 'Business unit'         | 'Store'    | 'Planning period' | 'Item key'                                | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | '-38'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Цех 06'                | 'Store 02' | 'First month'     | 'ПВД 158'                                 | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | '-20'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'First month'     | 'Копыта на стремянки Класс 30х20, черный' | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | '-10'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Коврик для стремянок Класс, черный'      | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'First month'     | 'Копыта на стремянки Класс 20х20, черный' | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Заклепка 6х47 полупустотелая'            | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Катанка Ст3сп 6,5'                       | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Краска порошковая серая 9006'            | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'труба электросварная круглая 10х1х5660'  | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Втулка на стремянки Класс 10 мм, черный' | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Скобы 3515 (Упаковочные)'                | '' |
			| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'ПВД 158'                                 | '' |
		And I close all client application windows

Scenario: _3055 check Production planning correction movements when unpost, re-post document
		* Check movements
			Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
			And I go to line in "List" table
				| 'Number'                               |
				| '$$NumberProductionPlanningCorrection01$$' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanningCorrection01$$' |
			Given I open hyperlink "e1cib/list/InformationRegister.T7010S_BillOfMaterials"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanningCorrection01$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7020T_MaterialPlanning"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanningCorrection01$$' |
			And I close all client application windows
		* Re-posting the document and checking movements on the registers
			* Posting the document
				Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
				And I go to line in "List" table
					| 'Number'                               |
					| '$$NumberProductionPlanningCorrection01$$' |
				And in the table "List" I click the button named "ListContextMenuPost"
			* Check movements
				And I click "Registrations report" button
				And I select "R7020 Material planning" exact value from "Register" drop-down list
				And I click "Generate report" button	
				And "ResultTable" spreadsheet document contains lines by template:
					| '$$ProductionPlanningCorrection01$$'  | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
					| 'Document registrations records'      | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
					| 'Register  "R7020 Material planning"' | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
					| ''                                    | 'Period'                                 | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
					| ''                                    | ''                                       | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Production'                              | 'Item key'                                | 'Planning type'   | 'Planning period' | 'Bill of materials'                          |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-150'      | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-100'      | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-50'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-38'       | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | 'Store 02' | 'Копыта на стремянки Класс 30х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'First month'     | '01 Копыта на стремянки Класс 30х20, черный' |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-19,6'     | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'First month'     | '01 Копыта на стремянки Класс 20х20'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-10'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Краска порошковая серая 9006'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '-10'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Коврик для стремянок Класс, черный'      | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '10'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Краска порошковая серая 9006'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '19,6'      | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'First month'     | '01 Копыта на стремянки Класс 20х20'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '50'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '100'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '150'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'First month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
				And I select "R7030 Production planning" exact value from "Register" drop-down list
				And I click "Generate report" button	
				And "ResultTable" spreadsheet document contains lines by template:
					| '$$ProductionPlanningCorrection01$$'    | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
					| 'Document registrations records'        | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
					| 'Register  "R7030 Production planning"' | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
					| ''                                      | 'Period'                                 | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
					| ''                                      | ''                                       | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Item key'                                | 'Planning type'   | 'Planning period' | 'Production type' | 'Bill of materials'                          |
					| ''                                      | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
					| ''                                      | '$$DateProductionPlanningCorrection01$$' | '-20'       | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | 'Store 01' | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'First month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 30х20, черный' |
					| ''                                      | '$$DateProductionPlanningCorrection01$$' | '-10'       | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Plan adjustment' | 'First month'     | 'Product'         | 'Стремянка CLASS PLUS 6 ступенчатая'         |
					| ''                                      | '$$DateProductionPlanningCorrection01$$' | '10'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Plan adjustment' | 'First month'     | 'Product'         | 'Стремянка CLASS PLUS 5 ступенчатая'         |
					| ''                                      | '$$DateProductionPlanningCorrection01$$' | '20'        | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'First month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
				And I select "T7010 Bill of materials" exact value from "Register" drop-down list
				And I click "Generate report" button	
				And "ResultTable" spreadsheet document contains lines by template:
					| '$$ProductionPlanningCorrection01$$'  | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
					| 'Document registrations records'      | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
					| 'Register  "T7010 Bill of materials"' | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
					| ''                                    | 'Period'                                 | 'Resources'                                  | ''     | ''         | ''           | ''               | 'Dimensions'   | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
					| ''                                    | ''                                       | 'Bill of materials'                          | 'Unit' | 'Quantity' | 'Basis unit' | 'Basis quantity' | 'Company'      | 'Planning document'      | 'Business unit'         | 'Input ID' | 'Output ID' | 'Unique ID' | 'Surplus store' | 'Writeoff store' | 'Item key'                                | 'Is product' | 'Is semiproduct' | 'Is material' | 'Is service' | 'Planning period' |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '90'       | 'pcs'        | '90'             | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Коврик для стремянок Класс, черный'      | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '180'      | 'pcs'        | '180'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '450'      | 'pcs'        | '450'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '520'      | 'pcs'        | '520'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '900'      | 'pcs'        | '900'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '1 300'    | 'pcs'        | '1 300'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '1 350'    | 'pcs'        | '1 350'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '2 600'    | 'pcs'        | '2 600'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'pcs'  | '3 900'    | 'pcs'        | '3 900'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '90'       | 'кг'         | '90'             | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Краска порошковая серая 9006'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '176,4'    | 'кг'         | '176,4'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '180'      | 'кг'         | '180'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '260'      | 'кг'         | '260'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Краска порошковая серая 9006'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '342'      | 'кг'         | '342'            | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | '*'        | ''          | '*'         | ''              | 'Store 02'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '509,6'    | 'кг'         | '509,6'          | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | ''                                           | 'кг'   | '520'      | 'кг'         | '520'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '180'      | 'pcs'        | '180'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '520'      | 'pcs'        | '520'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | '01 Копыта на стремянки Класс 30х20, черный' | 'pcs'  | '180'      | 'pcs'        | '180'            | 'Main Company' | 'Production planning 1*' | 'Цех 06'                | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 30х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | 'Стремянка CLASS PLUS 5 ступенчатая'         | 'pcs'  | '260'      | 'pcs'        | '260'            | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | ''         | '*'         | '*'         | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Yes'        | 'No'             | 'No'          | 'No'         | 'First month'     |
					| ''                                    | '$$DateProductionPlanningCorrection01$$' | 'Стремянка CLASS PLUS 6 ступенчатая'         | 'pcs'  | '90'       | 'pcs'        | '90'             | 'Main Company' | 'Production planning 1*' | 'Склад производства 05' | ''         | '*'         | '*'         | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 6 ступенчатая'      | 'Yes'        | 'No'             | 'No'          | 'No'         | 'First month'     |
				And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
				And I click "Generate report" button	
				And "ResultTable" spreadsheet document contains lines by template:	
					| 'Register  "R7010 Detailing supplies"' | ''                                       | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        | '' |
					| ''                                     | 'Period'                                 | 'Resources'             | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Dimensions'   | ''                      | ''         | ''                | ''                                        | '' |
					| ''                                     | ''                                       | 'Entry demand quantity' | 'Corrected demand quantity' | 'Needed produce quantity' | 'Produced produce quantity' | 'Reserved produce quantity' | 'Written off produce quantity' | 'Request procurement quantity' | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity' | 'Confirmed purchase quantity' | 'Company'      | 'Business unit'         | 'Store'    | 'Planning period' | 'Item key'                                | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | '-38'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Цех 06'                | 'Store 02' | 'First month'     | 'ПВД 158'                                 | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | '-20'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'First month'     | 'Копыта на стремянки Класс 30х20, черный' | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | '-10'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Коврик для стремянок Класс, черный'      | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'First month'     | 'Копыта на стремянки Класс 20х20, черный' | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Заклепка 6х47 полупустотелая'            | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Катанка Ст3сп 6,5'                       | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Краска порошковая серая 9006'            | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'труба электросварная круглая 10х1х5660'  | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Втулка на стремянки Класс 10 мм, черный' | '' |
					| ''                                     | '$$DateProductionPlanningCorrection01$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'First month'     | 'Скобы 3515 (Упаковочные)'                | '' |
				And I close all client application windows


Scenario: _3060 create production planning correction and check it movements (change bill of material+product that is not in the planning)
	// ThirdMonth
		And I close all client application windows
	* Create document
		And In the command interface I select "Manufacturing" "Production planning correction"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Склад производства 05' |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I move to "Productions" tab
		And I move to "Other" tab
		And I click Select button of "Planning period" field
		And I go to line in "List" table
			| 'Description' |
			| 'Third month' |
		And I select current line in "List" table	
		And I click Select button of "Production planning" field
		And I go to line in "List" table
			| 'Number' | 'Planning period' |
			| '3'      | 'Third month'    |
		And I activate "Date" field in "List" table
		And I select current line in "List" table
		Then the form attribute named "PlanningPeriod" became equal to "Third month"
		And I move to "Productions" tab
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I select current line in "List" table
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                        | 'Item'                               | 'Item key'                           | 
			| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I select current line in "List" table
		And "Productions" table contains lines
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Current Q' | 'Bill of materials'                  |
			| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' | 'pcs'  | '1,000' | ''          | 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I activate "Q" field in "Productions" table
		And I select current line in "Productions" table
		And I input "10" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Стремянка CLASS PLUS 8' |
		And I select current line in "List" table
		And "Productions" table contains lines
			| 'Item'                   | 'Item key'               | 'Unit' | 'Q'     | 'Current Q' | 'Bill of materials' |
			| 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' | 'pcs'  | '1,000' | ''          | ''                  |
		And I go to line in "Productions" table
			| 'Item'                   |
			| 'Стремянка CLASS PLUS 8' |
		And I activate "Bill of materials" field in "Productions" table
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                       |
			| 'Стремянка CLASS PLUS 8 (основная)' |
		And I select current line in "List" table		
		And I activate "Q" field in "Productions" table
		And I input "0" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And "Productions" table contains lines
			| 'Item'                   | 'Item key'               | 'Unit' | 'Q' | 'Current Q' | 'Bill of materials'                 |
			| 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' | 'pcs'  | ''  | '131,000'   | 'Стремянка CLASS PLUS 8 (основная)' |
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Стремянка CLASS PLUS 8' |
		And I select current line in "List" table
		And "Productions" table contains lines
			| 'Item'                   | 'Item key'               | 'Unit' | 'Q'     | 'Current Q' | 'Bill of materials' |
			| 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' | 'pcs'  | '1,000' | ''          | ''                  |
		And I go to line in "Productions" table
			| 'Item'                   | 'Q'     |
			| 'Стремянка CLASS PLUS 8' | '1,000' |
		And I activate "Bill of materials" field in "Productions" table
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                       |
			| 'Стремянка CLASS PLUS 8 (премиум)' |
		And I select current line in "List" table		
		And I activate "Q" field in "Productions" table
		And I input "131" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And "Productions" table contains lines
			| 'Item'                   | 'Item key'               | 'Unit' | 'Q'       | 'Current Q' | 'Bill of materials'                |
			| 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' | 'pcs'  | '131,000' | ''          | 'Стремянка CLASS PLUS 8 (премиум)' |
		And I move to "Other" tab
		And I click the button named "FormPost"
		And I delete "$$NumberProductionPlanningCorrection02$$" variable
		And I delete "$$ProductionPlanningCorrection02$$" variable
		And I delete "$$DateProductionPlanningCorrection02$$" variable
		And I save the value of "Number" field as "$$NumberProductionPlanningCorrection02$$"
		And I save the window as "$$ProductionPlanningCorrection02$$"
		And I save the value of the field named "Date" as "$$DateProductionPlanningCorrection02$$"
		And I close all client application windows
	* Check movements
		Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberProductionPlanningCorrection02$$' |
		And I click "Registrations report" button
		And I select "R7020 Material planning" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection02$$'  | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| 'Document registrations records'      | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| 'Register  "R7020 Material planning"' | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| ''                                    | 'Period'                                 | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| ''                                    | ''                                       | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Production'                              | 'Item key'                                | 'Planning type'   | 'Planning period' | 'Bill of materials'                          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-1 310'    | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-1 310'    | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-655'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-497,8'    | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | 'Store 02' | 'Копыта на стремянки Класс 30х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 30х20, черный' |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-262'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 8'                  | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-262'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 8'                  | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-262'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-262'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '-256,76'   | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '10'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Краска порошковая серая 9006'            | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '19,6'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '20'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '20'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '20'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '50'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '100'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '131'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Коврик для стремянок Класс, черный'      | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '150'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '256,76'    | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '262'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 8'                  | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '262'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 8'                  | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '262'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '262'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '497,8'     | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | 'Store 02' | 'Копыта на стремянки Класс 30х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 30х20, черный' |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '655'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '1 310'     | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '1 310'     | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
		And I select "R7030 Production planning" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:	
			| '$$ProductionPlanningCorrection02$$'    | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| 'Document registrations records'        | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| 'Register  "R7030 Production planning"' | ''                                       | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| ''                                      | 'Period'                                 | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                        | ''                | ''                | ''                | ''                                           |
			| ''                                      | ''                                       | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Item key'                                | 'Planning type'   | 'Planning period' | 'Production type' | 'Bill of materials'                          |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '-262'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '-262'      | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | 'Store 01' | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 30х20, черный' |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '-131'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 8'                  | 'Plan adjustment' | 'Third month'     | 'Product'         | 'Стремянка CLASS PLUS 8 (основная)'          |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '10'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Plan adjustment' | 'Third month'     | 'Product'         | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '20'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '131'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 8'                  | 'Plan adjustment' | 'Third month'     | 'Product'         | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '262'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                      | '$$DateProductionPlanningCorrection02$$' | '262'       | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | 'Store 01' | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 30х20, черный' |
		And I select "T7010 Bill of materials" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection02$$'  | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| 'Document registrations records'      | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| 'Register  "T7010 Bill of materials"' | ''                                       | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| ''                                    | 'Period'                                 | 'Resources'                                  | ''     | ''         | ''           | ''               | 'Dimensions'   | ''                       | ''                      | ''         | ''          | ''          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| ''                                    | ''                                       | 'Bill of materials'                          | 'Unit' | 'Quantity' | 'Basis unit' | 'Basis quantity' | 'Company'      | 'Planning document'      | 'Business unit'         | 'Input ID' | 'Output ID' | 'Unique ID' | 'Surplus store' | 'Writeoff store' | 'Item key'                                | 'Is product' | 'Is semiproduct' | 'Is material' | 'Is service' | 'Planning period' |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | ''         | 'pcs'        | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | ''         | 'pcs'        | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | ''         | 'pcs'        | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | ''         | 'pcs'        | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '20'       | 'pcs'        | '20'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '50'       | 'pcs'        | '50'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '100'      | 'pcs'        | '100'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '131'      | 'pcs'        | '131'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Коврик для стремянок Класс, черный'      | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '150'      | 'pcs'        | '150'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '262'      | 'pcs'        | '262'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '655'      | 'pcs'        | '655'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '1 310'    | 'pcs'        | '1 310'          | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'pcs'  | '1 310'    | 'pcs'        | '1 310'          | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | ''         | 'кг'         | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | ''         | 'кг'         | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | ''         | 'кг'         | ''               | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | '*'        | ''          | '*'         | ''              | 'Store 02'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | '10'       | 'кг'         | '10'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Краска порошковая серая 9006'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | '19,6'     | 'кг'         | '19,6'           | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | '20'       | 'кг'         | '20'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | '256,76'   | 'кг'         | '256,76'         | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | '262'      | 'кг'         | '262'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | ''          | '*'         | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | ''                                           | 'кг'   | '497,8'    | 'кг'         | '497,8'          | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | '*'        | ''          | '*'         | ''              | 'Store 02'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | ''         | 'pcs'        | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '20'       | 'pcs'        | '20'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '262'      | 'pcs'        | '262'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '01 Копыта на стремянки Класс 30х20, черный' | 'pcs'  | ''         | 'pcs'        | ''               | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 30х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | '01 Копыта на стремянки Класс 30х20, черный' | 'pcs'  | '262'      | 'pcs'        | '262'            | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | '*'        | '*'         | '*'         | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 30х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | 'Стремянка CLASS PLUS 5 ступенчатая'         | 'pcs'  | '10'       | 'pcs'        | '10'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | ''         | '*'         | '*'         | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Yes'        | 'No'             | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | 'Стремянка CLASS PLUS 8 (основная)'          | 'pcs'  | ''         | 'pcs'        | ''               | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | ''         | '*'         | '*'         | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 8'                  | 'Yes'        | 'No'             | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$DateProductionPlanningCorrection02$$' | 'Стремянка CLASS PLUS 8 (премиум)'           | 'pcs'  | '131'      | 'pcs'        | '131'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | ''         | '*'         | '*'         | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 8'                  | 'Yes'        | 'No'             | 'No'          | 'No'         | 'Third month'     |
		
		
					
		And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection02$$'   | ''                                       | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        |
			| 'Document registrations records'       | ''                                       | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        |
			| 'Register  "R7010 Detailing supplies"' | ''                                       | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        |
			| ''                                     | 'Period'                                 | 'Resources'             | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Dimensions'   | ''                      | ''         | ''                | ''                                        |
			| ''                                     | ''                                       | 'Entry demand quantity' | 'Corrected demand quantity' | 'Needed produce quantity' | 'Produced produce quantity' | 'Reserved produce quantity' | 'Written off produce quantity' | 'Request procurement quantity' | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity' | 'Confirmed purchase quantity' | 'Company'      | 'Business unit'         | 'Store'    | 'Planning period' | 'Item key'                                |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'Third month'     | 'Копыта на стремянки Класс 30х20, черный' |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Цех 06'                | 'Store 02' | 'Third month'     | 'ПВД 158'                                 |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '10'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Краска порошковая серая 9006'            |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '19,6'                      | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'ПВД 158'                                 |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '20'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'Third month'     | 'Копыта на стремянки Класс 20х20, черный' |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '20'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Катанка Ст3сп 6,5'                       |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '20'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'труба электросварная круглая 10х1х5660'  |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '50'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Втулка на стремянки Класс 10 мм, черный' |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '100'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Скобы 3515 (Упаковочные)'                |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '131'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Коврик для стремянок Класс, черный'      |
			| ''                                     | '$$DateProductionPlanningCorrection02$$' | ''                      | '150'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Заклепка 6х47 полупустотелая'            |
		
		
					
		And I close all client application windows



Scenario: _3070 create second production planning correction and check it movements (for one planning period)
	* Change user
		And I connect "TestAdmin" TestClient using "ABrown" login and "" password
	* Create document
		And In the command interface I select "Manufacturing" "Production planning correction"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Склад производства 05' |
		And I select current line in "List" table
		When I Check the steps for Exception
        	|'And I select "Approved" exact value from "Status" drop-down list'|
		And I move to "Productions" tab
		And I move to "Other" tab
		And I click Select button of "Planning period" field
		And I go to line in "List" table
			| 'Description' |
			| 'Third month' |
		And I select current line in "List" table
		And I click Select button of "Production planning" field
		And I go to line in "List" table
			| 'Number' | 'Planning period' |
			| '3'      | 'Third month'    |
		And I activate "Date" field in "List" table
		And I select current line in "List" table
		Then the form attribute named "PlanningPeriod" became equal to "Third month"
		And I move to "Productions" tab
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I select current line in "List" table
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I select current line in "List" table		
		And "Productions" table contains lines
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Current Q' | 'Bill of materials'                  |
			| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' | 'pcs'  | '1,000' | '10,000'    | 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I activate "Q" field in "Productions" table
		And I select current line in "Productions" table
		And I input "5" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Стремянка CLASS PLUS 8' |
		And I select current line in "List" table
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                       |
			| 'Стремянка CLASS PLUS 8 (премиум)' |
		And I select current line in "List" table		
		And I activate "Q" field in "Productions" table
		And I input "130" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And "Productions" table contains lines
			| 'Item'                   | 'Item key'               | 'Unit' | 'Q'       | 'Current Q' | 'Bill of materials'                |
			| 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' | 'pcs'  | '130,000' | '131,000'   | 'Стремянка CLASS PLUS 8 (премиум)' |
		And I click the button named "FormPost"
		And I delete "$$NumberProductionPlanningCorrection03$$" variable
		And I delete "$$ProductionPlanningCorrection03$$" variable
		And I save the value of "Number" field as "$$NumberProductionPlanningCorrection03$$"
		And I save the window as "$$ProductionPlanningCorrection03$$"
		And I close current window
		* Check that there is no movement on the registers (status)
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanningCorrection03$$' |
			Given I open hyperlink "e1cib/list/InformationRegister.T7010S_BillOfMaterials"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanningCorrection03$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7020T_MaterialPlanning"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanningCorrection03$$' |
			And I close all client application windows
		Then I connect launched Test client "Этот клиент"
	* Check movements
		Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberProductionPlanningCorrection03$$' |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Approved" exact value from "Status" drop-down list	
		And Delay 3
		And I click the button named "FormPost"
		And I delete "$$ApprovedDateProductionPlanningCorrection03$$" variable
		And I save the value of the field named "ApprovedDate" as "$$ApprovedDateProductionPlanningCorrection03$$"	
		And I click "Registrations report" button
		And I select "R7020 Material planning" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection03$$'  | ''                                               | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| 'Document registrations records'      | ''                                               | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| 'Register  "R7020 Material planning"' | ''                                               | ''          | ''             | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| ''                                    | 'Period'                                         | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                        | ''                                        | ''                | ''                | ''                                           |
			| ''                                    | ''                                               | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Production'                              | 'Item key'                                | 'Planning type'   | 'Planning period' | 'Bill of materials'                          |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-75'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-50'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-25'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-10'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-10'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-10'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-10'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Заклепка 6х47 полупустотелая'            | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-10'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Скобы 3515 (Упаковочные)'                | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-9,8'      | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-5'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Краска порошковая серая 9006'            | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-5'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Втулка на стремянки Класс 10 мм, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-3,8'      | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | 'Store 02' | 'Копыта на стремянки Класс 30х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 30х20, черный' |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-2'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 8'                  | 'Копыта на стремянки Класс 20х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-2'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 04' | 'Стремянка CLASS PLUS 8'                  | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-2'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Катанка Ст3сп 6,5'                       | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-2'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'труба электросварная круглая 10х1х5660'  | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-1,96'     | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Копыта на стремянки Класс 20х20, черный' | 'ПВД 158'                                 | 'Plan adjustment' | 'Third month'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '-1'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 07' | 'Стремянка CLASS PLUS 8'                  | 'Коврик для стремянок Класс, черный'      | 'Plan adjustment' | 'Third month'     | 'Стремянка CLASS PLUS 8 (премиум)'           |
		And I select "R7030 Production planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection03$$'    | ''                                               | ''          | ''             | ''                       | ''                      | ''         | ''                                         | ''                | ''                | ''                | ''                                           |
			| 'Document registrations records'        | ''                                               | ''          | ''             | ''                       | ''                      | ''         | ''                                         | ''                | ''                | ''                | ''                                           |
			| 'Register  "R7030 Production planning"' | ''                                               | ''          | ''             | ''                       | ''                      | ''         | ''                                         | ''                | ''                | ''                | ''                                           |
			| ''                                      | 'Period'                                         | 'Resources' | 'Dimensions'   | ''                       | ''                      | ''         | ''                                         | ''                | ''                | ''                | ''                                           |
			| ''                                      | ''                                               | 'Quantity'  | 'Company'      | 'Planning document'      | 'Business unit'         | 'Store'    | 'Item key'                                 | 'Planning type'   | 'Planning period' | 'Production type' | 'Bill of materials'                          |
			| ''                                      | '$$ApprovedDateProductionPlanningCorrection03$$' | '-10'       | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный'  | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                      | '$$ApprovedDateProductionPlanningCorrection03$$' | '-5'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 5 ступенчатая'       | 'Plan adjustment' | 'Third month'     | 'Product'         | 'Стремянка CLASS PLUS 5 ступенчатая'         |
			| ''                                      | '$$ApprovedDateProductionPlanningCorrection03$$' | '-2'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Копыта на стремянки Класс 20х20, черный'  | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 20х20'         |
			| ''                                      | '$$ApprovedDateProductionPlanningCorrection03$$' | '-2'        | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | 'Store 01' | 'Копыта на стремянки Класс 30х20, черный' | 'Plan adjustment' | 'Third month'     | 'Semiproduct'     | '01 Копыта на стремянки Класс 30х20, черный' |
			| ''                                      | '$$ApprovedDateProductionPlanningCorrection03$$' | '-1'        | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | 'Store 01' | 'Стремянка CLASS PLUS 8'                   | 'Plan adjustment' | 'Third month'     | 'Product'         | 'Стремянка CLASS PLUS 8 (премиум)'           |
		And I select "T7010 Bill of materials" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines by template:
			| '$$ProductionPlanningCorrection03$$'  | ''                                               | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''                                                | ''                                                | ''                                                                          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| 'Document registrations records'      | ''                                               | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''                                                | ''                                                | ''                                                                          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| 'Register  "T7010 Bill of materials"' | ''                                               | ''                                           | ''     | ''         | ''           | ''               | ''             | ''                       | ''                      | ''                                                | ''                                                | ''                                                                          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| ''                                    | 'Period'                                         | 'Resources'                                  | ''     | ''         | ''           | ''               | 'Dimensions'   | ''                       | ''                      | ''                                                | ''                                                | ''                                                                          | ''              | ''               | ''                                        | ''           | ''               | ''            | ''           | ''                |
			| ''                                    | ''                                               | 'Bill of materials'                          | 'Unit' | 'Quantity' | 'Basis unit' | 'Basis quantity' | 'Company'      | 'Planning document'      | 'Business unit'         | 'Input ID'                                        | 'Output ID'                                       | 'Unique ID'                                                                 | 'Surplus store' | 'Writeoff store' | 'Item key'                                | 'Is product' | 'Is semiproduct' | 'Is material' | 'Is service' | 'Planning period' |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '10'       | 'pcs'        | '10'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | ''                                                | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '25'       | 'pcs'        | '25'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | ''                                                | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '50'       | 'pcs'        | '50'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | ''                                                | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '75'       | 'pcs'        | '75'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | ''                                                | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '130'      | 'pcs'        | '130'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Коврик для стремянок Класс, черный'      | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '260'      | 'pcs'        | '260'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'труба электросварная круглая 10х1х5660'  | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '650'      | 'pcs'        | '650'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Втулка на стремянки Класс 10 мм, черный' | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '1 300'    | 'pcs'        | '1 300'          | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Заклепка 6х47 полупустотелая'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'pcs'  | '1 300'    | 'pcs'        | '1 300'          | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Скобы 3515 (Упаковочные)'                | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'кг'   | '5'        | 'кг'         | '5'              | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | ''                                                | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Краска порошковая серая 9006'            | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'кг'   | '9,8'      | 'кг'         | '9,8'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '5B 6E BF 5D 12 19 EC 09 FF 3D 84 89 90 C3 76 6F' | ''                                                | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'кг'   | '10'       | 'кг'         | '10'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | ''                                                | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'кг'   | '254,8'    | 'кг'         | '254,8'          | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '57 B6 B7 C3 AD 31 64 9C 66 72 D1 0A A7 75 77 20' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'кг'   | '260'      | 'кг'         | '260'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 07'       | 'Катанка Ст3сп 6,5'                       | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                                           | 'кг'   | '494'      | 'кг'         | '494'            | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | '39 D5 A2 61 A4 12 AB 4B BC 80 AC D5 51 77 39 E3' | ''                                                | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | ''              | 'Store 02'       | 'ПВД 158'                                 | 'No'         | 'No'             | 'Yes'         | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '10'       | 'pcs'        | '10'             | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | '5B 6E BF 5D 12 19 EC 09 FF 3D 84 89 90 C3 76 6F' | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '01 Копыта на стремянки Класс 20х20'         | 'pcs'  | '260'      | 'pcs'        | '260'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | '57 B6 B7 C3 AD 31 64 9C 66 72 D1 0A A7 75 77 20' | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 20х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | '01 Копыта на стремянки Класс 30х20, черный' | 'pcs'  | '260'      | 'pcs'        | '260'            | 'Main Company' | 'Production planning 3*' | 'Цех 06'                | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | '39 D5 A2 61 A4 12 AB 4B BC 80 AC D5 51 77 39 E3' | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | 'Store 01'      | 'Store 04'       | 'Копыта на стремянки Класс 30х20, черный' | 'No'         | 'Yes'            | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | 'Стремянка CLASS PLUS 5 ступенчатая'         | 'pcs'  | '5'        | 'pcs'        | '5'              | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | ''                                                | '4C EB F9 EF E8 C6 08 5C F3 89 54 C1 60 EC 8A 77' | '2b45dcf0-1f6d-11eb-bb8d-0050560061d6-c6358736-5cca-11eb-b760-b47469bcb0d7' | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 5 ступенчатая'      | 'Yes'        | 'No'             | 'No'          | 'No'         | 'Third month'     |
			| ''                                    | '$$ApprovedDateProductionPlanningCorrection03$$' | 'Стремянка CLASS PLUS 8 (премиум)'           | 'pcs'  | '130'      | 'pcs'        | '130'            | 'Main Company' | 'Production planning 3*' | 'Склад производства 05' | ''                                                | '77 F7 D4 84 F5 B3 70 41 B1 C4 17 9B 4D B4 F2 DA' | 'f431e8c8-22a2-11eb-bb8d-0050560061d6-c6358739-5cca-11eb-b760-b47469bcb0d7' | 'Store 01'      | ''               | 'Стремянка CLASS PLUS 8'                  | 'Yes'        | 'No'             | 'No'          | 'No'         | 'Third month'     |
		And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
		And I click "Generate report" button	
		And "ResultTable" spreadsheet document contains lines by template:	
			| '$$ProductionPlanningCorrection03$$'   | ''                                               | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        |
			| 'Document registrations records'       | ''                                               | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        |
			| 'Register  "R7010 Detailing supplies"' | ''                                               | ''                      | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | ''             | ''                      | ''         | ''                | ''                                        |
			| ''                                     | 'Period'                                         | 'Resources'             | ''                          | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Dimensions'   | ''                      | ''         | ''                | ''                                        |
			| ''                                     | ''                                               | 'Entry demand quantity' | 'Corrected demand quantity' | 'Needed produce quantity' | 'Produced produce quantity' | 'Reserved produce quantity' | 'Written off produce quantity' | 'Request procurement quantity' | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity' | 'Confirmed purchase quantity' | 'Company'      | 'Business unit'         | 'Store'    | 'Planning period' | 'Item key'                                |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-85'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Заклепка 6х47 полупустотелая'            |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-60'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Скобы 3515 (Упаковочные)'                |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-30'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Втулка на стремянки Класс 10 мм, черный' |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-12'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'Third month'     | 'Копыта на стремянки Класс 20х20, черный' |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-12'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Катанка Ст3сп 6,5'                       |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-12'                       | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'труба электросварная круглая 10х1х5660'  |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-11,76'                    | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'ПВД 158'                                 |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-5'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Краска порошковая серая 9006'            |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-3,8'                      | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Цех 06'                | 'Store 02' | 'Third month'     | 'ПВД 158'                                 |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-2'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 04' | 'Third month'     | 'Копыта на стремянки Класс 30х20, черный' |
			| ''                                     | '$$ApprovedDateProductionPlanningCorrection03$$' | ''                      | '-1'                        | ''                        | ''                          | ''                          | ''                             | ''                             | ''                        | ''                            | ''                        | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 07' | 'Third month'     | 'Коврик для стремянок Класс, черный'      |
	And I close all client application windows
	





	

	
		
	


				




		
				


		
	






		



