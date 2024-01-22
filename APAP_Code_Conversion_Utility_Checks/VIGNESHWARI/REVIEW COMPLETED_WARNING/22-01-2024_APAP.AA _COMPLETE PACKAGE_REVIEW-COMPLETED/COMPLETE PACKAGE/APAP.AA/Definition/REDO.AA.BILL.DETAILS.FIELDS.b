* @ValidationCode : MjotMTkyMTUwMjUwNjpDcDEyNTI6MTY4NTk0OTA1ODM2MjpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:40:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.AA.BILL.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : NA
* Deals With     : AA.BILL.DETAILS
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                          DESCRIPTION
* 06-FEB-2011     H GANESH     PACS00178946 CR-PENALTY CHARGE               Initial Draft.
* 18.05.2023   Conversion Tool              R22                         Auto Conversion     - FM TO @FM
* 18.05.2023   Shanmugapriya M              R22                         Manual Conversion   - REDO.LCCY TO LCCY
*
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_METHODS.AND.PROPERTIES
    $INSERT I_F.CURRENCY
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.REDO.AA.BILL.DETAILS
    $INSERT I_F.AA.PROPERTY
*-----------------------------------------------------------------------------

*GOSUB INITIALISE
    GOSUB DEFINE.FIELDS

RETURN

*** </region>
*-----------------------------------------------------------------------------

*** <region name= Initialise>
*** <desc>Create virtual tables and define check files</desc>
INITIALISE:

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

    CHK$CURRENCY = "CURRENCY":@FM:EB.CUR.CCY.NAME:@FM:"L"            ;** R22 Auto conversion

    OVERDUE.STATUS = ""
    OVERDUE.STATUS = "AA.OVERDUE.STATUS"
    CALL EB.LOOKUP.LIST(OVERDUE.STATUS)

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Field definition>
*** <desc>Field definition</desc>
DEFINE.FIELDS:

    ID.F = "BILL.REFERENCE" ; ID.N = "80" ; ID.T = "A"



    fieldName='ARRANGEMENT.ID'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='PAYMENT.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)




    fieldName='ACTUAL.PAY.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='DEFER.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='FINANCIAL.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='CURRENCY'
    fieldLength='3'
    fieldType='CCY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")



    fieldName='OR.TOTAL.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

   
    fieldName='OR.TOTAL.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY       ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='DELIN.OS.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='DELIN.OS.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                  ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='OS.TOTAL.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='OS.TOTAL.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                       ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='OS.TOTAL.ADJ.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='OS.TOTAL.ADJ.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY              ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='R.TOT.AMOUNT.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='RESERVED.16'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='OS.TOT.AMOUNT.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='RESERVED.15'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='OS.TOT.ADJ.AMT.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ORESERVED.14'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<PROPERTY'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")



    fieldName='XX-OR.PROP.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-OR.PROP.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                 ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-OS.PROP.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-OS.PROP.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                    ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-OS.ADJ.PROP.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-OS.ADJ.PROP.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                  ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-SUS.PROP.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-SUS.PROP.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY               ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-OR.PROP.AMT.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-RESERVED.13'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-OS.PROP.AMT.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-RESERVED.12'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-OS.ADJ.PROP.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-RESERVED.11'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-SUS.PROP.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-RESERVED.10'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-WAIVE.PROP.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-WAIVE.PROP.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                  ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-XX<REPAY.REF'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX>REPAY.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-XX-REPAY.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                  ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-REPAY.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX>RESERVED.9'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX<CHARGEOFF.REF'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX>CHARGEOFF.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-XX<ADJUST.REF'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX>ADJUST.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-ADJUST.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                      ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-ADJ.AMT.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX>RESERVED.8'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX<WRITEOFF.REF'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>XX>WRITEOFF.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-WRITEOFF.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-WRITEOFF.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>XX>RESERVED.7'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<BILL.STATUS'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>BILL.ST.CHG.DT'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<RESERVED.19'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>RESERVED.20'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<SETTLE.STATUS'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>SET.ST.CHG.DT'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<RESERVED.21'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>RESERVED.22'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<AGING.STATUS'
    fieldLength = '30'
    fieldType = ''
    neighbour = ''
    virtualTableName='OVERDUE.STATUS'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)



    fieldName='XX>AGING.ST.CHG.DT'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX<RESERVED.17'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>RESERVED.18'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX<PAYMENT.TYPE'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-BILL.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-BILL.TYPE'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-BILL.FINAL.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-PAYMENT.METHOD'
    fieldLength='10'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-PAYMENT.AMOUNT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-PAYMENT.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                   ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-PAYMENT.AMT.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-RESERVED.6'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX<PAY.PROPERTY'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")


    fieldName='XX-XX-OR.PR.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-OR.PR.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                    ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-OS.PR.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-OS.PR.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                      ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX-XX-SUS.PR.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-SUS.PR.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                     ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName='XX>XX>OS.AD.PR.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-OS.AD.PR.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX-XX-OR.PR.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-RESERVED.5'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-OS.PR.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-RESERVED.3'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-SUS.PR.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-RESERVED.2'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-OS.ADJ.PR.BNK'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-RESERVED.1'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX-WAIVE.PR.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>XX>WAIVE.PR.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY              ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<INFO.PAY.TYPE'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX-XX<INFO.PAY.PRP'
    fieldLength='15'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("AA.PROPERTY")


    fieldName='XX>XX>INFO.PR.AMT'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = REDO.AA.BD.CURRENCY
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>XX>INFO.PR.AMT.LCY'
    fieldLength='19'
    fieldType='AMT'
    fieldType<2,2> = LCCY                 ;* R22 Manual conversion
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='ADVANCE.PAYMENT'
    fieldLength='3'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='LAST.UPDATE.DATE'
    fieldLength='15'
    fieldType='RELTIME'
    fieldType<4> = "RDD DD  DD ##:##"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX<DELIN.REP.REF'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>DELIN.AMT'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX.AGING.REF'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='ADVANCE.BILL'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='DUE.REFERENCE'
    fieldLength='40'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='DEFER.REFERENCE'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='PAYMENT.INDICATOR'
    fieldLength='10'
    fieldType=''
    fieldType<2> = "DEBIT_CREDIT"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX<CAPTURE.PROPERTY'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='XX>CAPTURE.PROPERTY.AMT'
    fieldLength='30'
    fieldType='AA'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.setAuditPosition

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------

END
