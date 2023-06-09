* @ValidationCode : MjotMTgzNDgwOTYzNTpDcDEyNTI6MTY4MDc2MDA2NjcwMTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 11:17:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1(Y.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST,Y.FT.OUT.LIST)
*---------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAP.GL.DETAIL.RPT.SPLIT.1
*-------------------------------------------------------------------------------------------------------
*Description  :This routine is used to get detail report of all the transactions for the given day
*Linked With  : Routine REDO.APAP.SAP.GL.DETAIL.RPT
*In Parameter : Y.ENTRY.ID,Y.ENTRY.INDICATOR,Y.PARAM.DETAILS.LIST
*Out Parameter: Y.FT.OUT.LIST
*
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 OCT  2010    Mohammed Anies K      ODR-2009-12-0294 C.12    Initial Creation
* 19 SEP 2018     Gopala Krishnan R     PACS00697301             Fix Modification
* Date                   who                   Reference              
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND X TO X.VAR AND = TO EQ
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.RE.TXN.CODE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.APAP.SAP.GL.DETAIL.COMMON
*--------------------------------------------------------------------------------------------------------
**********
*MAIN.PARA:
**********
* Start of the program

    Y.CLIENT.ID=''
    Y.CLIENT.TYPE=''
    Y.RE.TXN.DESC=''
    Y.SAP.COST.CENTER=''
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
** This is the main processing para
    Y.IGN.TXN.CODES       = Y.PARAM.DETAILS.LIST<1>
    Y.PARAM.DEBIT.FORMAT  = Y.PARAM.DETAILS.LIST<2>
    Y.PARAM.CREDIT.FORMAT = Y.PARAM.DETAILS.LIST<3>
    Y.SAP.ACC.NO          = Y.PARAM.DETAILS.LIST<4>
    Y.SIB.ACC.NO          = Y.PARAM.DETAILS.LIST<5>
    Y.CLOSE.DATE          = Y.PARAM.DETAILS.LIST<6>
    Y.FLD.DELIM           = Y.PARAM.DETAILS.LIST<7>

    Y.STMT.AMOUNT.CR=''
    Y.STMT.AMOUNT.DR=''
    Y.STMT.AMOUNT.FCY.CR=''
    Y.STMT.AMOUNT.FCY.DR=''
    Y.SPEC.AMOUNT.CR=''
    Y.SPEC.AMOUNT.DR=''
    Y.SPEC.AMOUNT.FCY.CR=''
    Y.SPEC.AMOUNT.FCY.DR=''
    Y.CATEG.AMOUNT.CR=''
    Y.CATEG.AMOUNT.DR=''
    Y.CATEG.AMOUNT.FCY.CR=''
    Y.CATEG.AMOUNT.FCY.DR=''

    GOSUB CHECK.DIF.CASE
RETURN

*--------------
CHECK.DIF.CASE:
*--------------
    BEGIN CASE

        CASE Y.ENTRY.INDICATOR EQ 'STMT.ENTRY'        ;* If indicator is STMT.ENTRY

            Y.STMT.ENTRY.ID = Y.ENTRY.ID
            Y.COUNT.DELIMITER = COUNT(Y.STMT.ENTRY.ID,'!')
            R.STMT.ENTRY.DETAIL = ''
            IF Y.COUNT.DELIMITER GT 0 THEN
                GOSUB GET.STMT.ENTRY.DETIALS
                RETURN
            END
            R.STMT.ENTRY = ''
            CALL F.READ(FN.STMT.ENTRY,Y.STMT.ENTRY.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
            IF NOT(R.STMT.ENTRY) THEN
                RETURN
            END
* 20170926 /S
            IF R.STMT.ENTRY<AC.STE.BOOKING.DATE> NE PROCESS.DATE THEN
* 20170926 /E
                RETURN
            END
            R.STMT.ENTRY.DETAIL = R.STMT.ENTRY
            GOSUB PROCESS.STMT.DETAILS

        CASE Y.ENTRY.INDICATOR EQ 'CATEG.ENTRY'       ;* If indicator is CATEG.ENTRY

            Y.CATEG.ENTRY.ID = Y.ENTRY.ID
            Y.COUNT.DELIMITER = COUNT(Y.CATEG.ENTRY.ID,'!')
            R.CATEG.ENTRY.DETAIL = ''
            IF Y.COUNT.DELIMITER GT 0 THEN
                GOSUB GET.CATEG.ENTRY.DETAILS
                RETURN
            END
            R.CATEG.ENTRY = ''
            CALL F.READ(FN.CATEG.ENTRY,Y.CATEG.ENTRY.ID,R.CATEG.ENTRY,F.CATEG.ENTRY,CATEG.ENTRY.ERR)
            IF NOT(R.CATEG.ENTRY) THEN
                RETURN
            END
* 20170926 /S
            IF R.CATEG.ENTRY<AC.CAT.BOOKING.DATE> NE PROCESS.DATE THEN
* 20170926 /E
                RETURN
            END
            R.CATEG.ENTRY.DETAIL = R.CATEG.ENTRY
            GOSUB PROCESS.CATEG.DETAILS

        CASE Y.ENTRY.INDICATOR EQ 'SPEC.ENTRY'        ;* If indicator is SPEC.ENTRY

            Y.RE.CONSOL.SPEC.ENTRY.ID = Y.ENTRY.ID
            Y.COUNT.DELIMITER = COUNT(Y.RE.CONSOL.SPEC.ENTRY.ID,'!')
            R.RE.SPEC.ENTRY.DETAIL = ''
            IF Y.COUNT.DELIMITER GT 0 THEN
                GOSUB GET.RE.SPEC.ENTRY.DETIALS
                RETURN
            END
            R.RE.CONSOL.SPEC.ENTRY = ''
            CALL F.READ(FN.RE.CONSOL.SPEC.ENTRY,Y.RE.CONSOL.SPEC.ENTRY.ID,R.RE.CONSOL.SPEC.ENTRY,F.RE.CONSOL.SPEC.ENTRY,RE.CONSOL.SPEC.ENTRY.ERR)
            IF NOT(R.RE.CONSOL.SPEC.ENTRY) THEN
                RETURN
            END
* 20170926 /S
            IF R.RE.CONSOL.SPEC.ENTRY<RE.CSE.BOOKING.DATE> NE PROCESS.DATE THEN
* 20170926 /E
                RETURN
            END
            R.RE.SPEC.ENTRY.DETAIL = R.RE.CONSOL.SPEC.ENTRY
            GOSUB PROCESS.SPEC.DETAILS
    END CASE
    IF Y.SP.COMPANY.POS THEN
        Y.NOR.AMT<Y.SP.COMPANY.POS,5>=Y.SAP.COST.CENTER
    END
RETURN
*--------------------------------------------------------------------------------------------------------
***********************
GET.STMT.ENTRY.DETIALS:
***********************
    X.VAR=1
    LOOP
        Y.STMT.ENTRY.XREF.ID = Y.STMT.ENTRY.ID:'-':X.VAR        ;* forming the STMT.ENTRY.XREF ID
        R.STMT.ENTRY.DETAIL.XREF = ''
        STMT.ENTRY.DETAIL.XREF.ERR = ''
        CALL F.READ(FN.STMT.ENTRY.DETAIL.XREF,Y.STMT.ENTRY.XREF.ID,R.STMT.ENTRY.DETAIL.XREF,F.STMT.ENTRY.DETAIL.XREF,STMT.ENTRY.DETAIL.XREF.ERR)
    WHILE NOT(STMT.ENTRY.DETAIL.XREF.ERR)
        X.VAR += 1
        LOOP
            REMOVE Y.STMT.DETAIL.ID FROM R.STMT.ENTRY.DETAIL.XREF SETTING Y.STMT.DETAIL.ID.POS
        WHILE Y.STMT.DETAIL.ID : Y.STMT.DETAIL.ID.POS
            CALL F.READ(FN.STMT.ENTRY.DETAIL,Y.STMT.DETAIL.ID,R.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL,STMT.ENTRY.DETAIL.ERR)
            GOSUB PROCESS.STMT.DETAILS
        REPEAT
    REPEAT

    IF STMT.ENTRY.DETAIL.XREF.ERR AND X.VAR EQ 1 THEN  ;*R22 AUTO CONVERSTION X TO X.VAR AND = TO EQ
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ENTRY.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        R.STMT.ENTRY.DETAIL = R.STMT.ENTRY
        GOSUB PROCESS.STMT.DETAILS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************************
GET.CATEG.ENTRY.DETAILS:
************************
    Y.CATEG.ENTRY.XREF.ID = Y.CATEG.ENTRY.ID:'-1' ;* forming the CATEG.ENTRY.XREF ID
    R.CATEG.ENTRY.DETAIL.XREF = ''
    CATEG.ENTRY.DETAIL.XREF.ERR = ''
    CALL F.READ(FN.CATEG.ENTRY.DETAIL.XREF,Y.CATEG.ENTRY.XREF.ID,R.CATEG.ENTRY.DETAIL.XREF,F.CATEG.ENTRY.DETAIL.XREF,CATEG.ENTRY.DETAIL.XREF.ERR)

    IF R.CATEG.ENTRY.DETAIL.XREF EQ '' THEN
        CALL F.READ(FN.CATEG.ENTRY,Y.CATEG.ENTRY.ID,R.CATEG.ENTRY,F.CATEG.ENTRY,CATEG.ENTRY.ERR)
        R.CATEG.ENTRY.DETAIL = R.CATEG.ENTRY
        GOSUB PROCESS.CATEG.DETAILS
    END

    LOOP
        REMOVE Y.CATEG.DETAIL.ID FROM R.CATEG.ENTRY.DETAIL SETTING Y.CATEG.DETAIL.ID.POS
    WHILE Y.CATEG.DETAIL.ID : Y.CATEG.DETAIL.ID.POS
        CALL F.READ(FN.CATEG.ENTRY.DETAIL,Y.CATEG.DETAIL.ID,R.CATEG.ENTRY.DETAIL,F.CATEG.ENTRY.DETAIL,CATEG.ENTRY.DETAIL.ERR)
        GOSUB PROCESS.CATEG.DETAILS
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
GET.RE.SPEC.ENTRY.DETIALS:
**************************
    Y.SPEC.ENTRY.XREF.ID = Y.RE.CONSOL.SPEC.ENTRY.ID:'-1'   ;* forming the SPEC.ENTRY.XREF ID
    R.RE.SPEC.ENTRY.XREF = ''
    RE.SPEC.ENTRY.XREF.ERR = ''
    CALL F.READ(FN.RE.SPEC.ENTRY.XREF,Y.SPEC.ENTRY.XREF.ID,R.RE.SPEC.ENTRY.XREF,F.RE.SPEC.ENTRY.XREF,RE.SPEC.ENTRY.XREF.ERR)

    IF R.RE.SPEC.ENTRY.XREF EQ '' THEN
        CALL F.READ(FN.RE.CONSOL.SPEC.ENTRY,Y.RE.CONSOL.SPEC.ENTRY.ID,R.RE.CONSOL.SPEC.ENTRY,F.RE.CONSOL.SPEC.ENTRY,RE.CONSOL.SPEC.ENTRY.ERR)
        R.RE.SPEC.ENTRY.DETAIL = R.RE.CONSOL.SPEC.ENTRY
        GOSUB PROCESS.SPEC.DETAILS
        RETURN
    END

    LOOP
        REMOVE Y.SPEC.DETAIL.ID FROM R.RE.SPEC.ENTRY.XREF SETTING Y.SPEC.DETAIL.ID.POS
    WHILE Y.SPEC.DETAIL.ID : Y.SPEC.DETAIL.ID.POS
        CALL F.READ(FN.RE.SPEC.ENTRY.DETAIL,Y.SPEC.DETAIL.ID,R.RE.SPEC.ENTRY.DETAIL,F.RE.SPEC.ENTRY.DETAIL,RE.SPEC.ENTRY.DETAIL.ERR)
        GOSUB PROCESS.SPEC.DETAILS
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
********************
PROCESS.STMT.DETAILS:
********************
* 20170926 /S
    IF R.STMT.ENTRY.DETAIL<AC.STE.BOOKING.DATE> NE PROCESS.DATE THEN
* 20170926 /E
        RETURN
    END
*para of code to get stmt entry details
    Y.STMT.TXN.CODE = R.STMT.ENTRY.DETAIL<AC.STE.TRANSACTION.CODE>

    LOCATE Y.STMT.TXN.CODE IN Y.IGN.TXN.CODES<1,1> SETTING Y.IGN.STMT.POS THEN
        IF Y.STMT.TXN.CODE NE '' THEN
            RETURN
        END
    END

    Y.TRANS.REFERENCE = R.STMT.ENTRY.DETAIL<AC.STE.TRANS.REFERENCE>
    Y.COMPANY.MNE = FIELD(Y.TRANS.REFERENCE,'\',2,1)
    Y.COMPANY.ID  = R.STMT.ENTRY.DETAIL<AC.STE.COMPANY.CODE>
    Y.VALUE.DATE  = R.STMT.ENTRY.DETAIL<AC.STE.VALUE.DATE>
    IF NOT(Y.VALUE.DATE) THEN
        Y.VALUE.DATE  = R.STMT.ENTRY.DETAIL<AC.STE.BOOKING.DATE>
    END
    GOSUB GET.SAP.COST.CENTER
    IF Y.FT.OUT.LIST THEN
        Y.FT.OUT.LIST:=@FM
    END
    Y.FT.OUT.LIST :=  Y.CLOSE.DATE:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.COMPANY.ID:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.VALUE.DATE:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SAP.COST.CENTER:Y.FLD.DELIM
    Y.FT.OUT.LIST :=R.STMT.ENTRY.DETAIL<AC.STE.PRODUCT.CATEGORY>:Y.FLD.DELIM
    Y.FT.OUT.LIST :=R.STMT.ENTRY.DETAIL<AC.STE.ACCOUNT.NUMBER>:Y.FLD.DELIM
    Y.CUSTOMER.ID = R.STMT.ENTRY.DETAIL<AC.STE.CUSTOMER.ID>

    IF NOT(Y.CUSTOMER.ID) THEN
        Y.ACCOUNT.ID=R.STMT.ENTRY.DETAIL<AC.STE.OUR.REFERENCE>
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR)
        Y.CUSTOMER.ID=R.ACCOUNT<AC.CUSTOMER>
    END
    Y.FT.OUT.LIST :=Y.CUSTOMER.ID:Y.FLD.DELIM
    IF Y.CUSTOMER.ID THEN
        GOSUB GET.CUSTOMER.DET
    END
    Y.FT.OUT.LIST :=Y.CLIENT.ID:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.CLIENT.TYPE:Y.FLD.DELIM
    Y.STMT.CURRENCY= R.STMT.ENTRY.DETAIL<AC.STE.CURRENCY>
    Y.FT.OUT.LIST := Y.STMT.CURRENCY:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.STMT.TXN.CODE:Y.FLD.DELIM
    Y.GENERAL.TXN.CODE = Y.STMT.TXN.CODE
    GOSUB GET.TXN.DESC
    Y.FT.OUT.LIST := Y.TXN.CODE.DESC:Y.FLD.DELIM
    Y.EXCH.RATE    = R.STMT.ENTRY.DETAIL<AC.STE.EXCHANGE.RATE>
    Y.FT.OUT.LIST :=Y.EXCH.RATE:Y.FLD.DELIM

    Y.STMT.AMOUNT  = 0
    Y.STMT.AMOUNT     = R.STMT.ENTRY.DETAIL<AC.STE.AMOUNT.LCY>
    IF Y.STMT.AMOUNT GT 0 THEN
        Y.STMT.AMOUNT.CR=Y.STMT.AMOUNT
        Y.NOR.AMT<Y.SP.COMPANY.POS,1>+=Y.STMT.AMOUNT.CR
    END
    IF Y.STMT.AMOUNT LT 0 THEN
        Y.STMT.AMOUNT.DR=Y.STMT.AMOUNT
        Y.NOR.AMT<Y.SP.COMPANY.POS,2>+=Y.STMT.AMOUNT.DR
    END

    Y.STMT.AMOUNT.FCY = R.STMT.ENTRY.DETAIL<AC.STE.AMOUNT.FCY>

    IF Y.STMT.AMOUNT.FCY GT 0 THEN
        Y.STMT.AMOUNT.FCY.CR=Y.STMT.AMOUNT.FCY
        Y.NOR.AMT<Y.SP.COMPANY.POS,3>+=Y.STMT.AMOUNT.FCY.CR
    END
    IF Y.STMT.AMOUNT.FCY LT 0 THEN
        Y.STMT.AMOUNT.FCY.DR=Y.STMT.AMOUNT.FCY
        Y.NOR.AMT<Y.SP.COMPANY.POS,4>+=Y.STMT.AMOUNT.FCY.DR
    END
    IF Y.SP.COMPANY.POS THEN
        Y.NOR.AMT<Y.SP.COMPANY.POS,5>=Y.SAP.COST.CENTER
    END

    Y.FT.OUT.LIST :=Y.STMT.AMOUNT.DR:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.STMT.AMOUNT.CR:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.STMT.AMOUNT.FCY.DR:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.STMT.AMOUNT.FCY.CR:Y.FLD.DELIM
    Y.FT.OUT.LIST := R.STMT.ENTRY.DETAIL<AC.STE.CONSOL.KEY>:'.':R.STMT.ENTRY.DETAIL<AC.STE.CRF.TYPE>:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SAP.ACC.NO:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SIB.ACC.NO:Y.FLD.DELIM
    Y.USER.NAME    =R.STMT.ENTRY.DETAIL<AC.STE.INPUTTER>
    Y.USER.NAME    =FIELD(Y.USER.NAME,'_',2,1)
    Y.FT.OUT.LIST := Y.USER.NAME

RETURN
*--------------------------------------------------------------------------------------------------------
************
AMOUNT.CALC:
************
    IF Y.GOSUB.AMT LT 0 THEN
        Y.DB.CR.IND = 'DB'
        IF Y.PARAM.DEBIT.FORMAT EQ '+' THEN
            Y.GOSUB.AMT = (-1)*Y.GOSUB.AMT
        END
    END ELSE
        Y.DB.CR.IND = 'CR'
        IF Y.PARAM.CREDIT.FORMAT EQ '-' THEN
            Y.GOSUB.AMT = (-1)*Y.GOSUB.AMT
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
PROCESS.SPEC.DETAILS:
********************
* 20170926 /S
    IF R.RE.SPEC.ENTRY.DETAIL<RE.CSE.BOOKING.DATE> NE PROCESS.DATE THEN
* 20170926 /E
        RETURN
    END
*para of code to get spec entry details
    Y.SPEC.TXN.CODE = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.TRANSACTION.CODE>

    LOCATE Y.SPEC.TXN.CODE IN Y.IGN.TXN.CODES<1,1> SETTING Y.IGN.SPEC.POS THEN
        IF Y.SPEC.TXN.CODE NE '' THEN
            RETURN
        END
    END
    Y.TRANS.REFERENCE = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.TRANS.REFERENCE>
    Y.COMPANY.MNE = FIELD(Y.TRANS.REFERENCE,'\',2,1)
    Y.COMPANY.ID  = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.COMPANY.CODE>
    Y.VALUE.DATE  = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.VALUE.DATE>
    IF NOT(Y.VALUE.DATE) THEN
        Y.VALUE.DATE  = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.BOOKING.DATE>
    END
    GOSUB GET.SAP.COST.CENTER
    IF Y.FT.OUT.LIST THEN
        Y.FT.OUT.LIST:=@FM
    END
    Y.FT.OUT.LIST :=  Y.CLOSE.DATE:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.COMPANY.ID:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.VALUE.DATE:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SAP.COST.CENTER:Y.FLD.DELIM
    Y.FT.OUT.LIST :=R.RE.SPEC.ENTRY.DETAIL<RE.CSE.PRODUCT.CATEGORY>:Y.FLD.DELIM
    Y.FT.OUT.LIST :=R.RE.SPEC.ENTRY.DETAIL<RE.CSE.DEAL.NUMBER>:Y.FLD.DELIM
    Y.CUSTOMER.ID = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.CUSTOMER.ID>
    IF NOT(Y.CUSTOMER.ID) THEN
        Y.ACCOUNT.ID=R.RE.SPEC.ENTRY.DETAIL<RE.CSE.OUR.REFERENCE>
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR)
        Y.CUSTOMER.ID=R.ACCOUNT<AC.CUSTOMER>
    END
    Y.FT.OUT.LIST :=Y.CUSTOMER.ID:Y.FLD.DELIM
    IF Y.CUSTOMER.ID THEN
        GOSUB GET.CUSTOMER.DET
    END
    Y.FT.OUT.LIST :=Y.CLIENT.ID:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.CLIENT.TYPE:Y.FLD.DELIM
    Y.SPEC.CURRENCY = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.CURRENCY>
    Y.FT.OUT.LIST := Y.SPEC.CURRENCY:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.SPEC.TXN.CODE:Y.FLD.DELIM
    GOSUB GET.RE.TXN.DESC
    Y.FT.OUT.LIST :=Y.RE.TXN.DESC:Y.FLD.DELIM
    Y.EXCH.RATE    =R.RE.SPEC.ENTRY.DETAIL<RE.CSE.EXCHANGE.RATE>
    Y.FT.OUT.LIST :=Y.EXCH.RATE:Y.FLD.DELIM
    Y.SPEC.AMOUNT = 0
    Y.SPEC.AMOUNT = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.AMOUNT.LCY>
    Y.SPEC.AMOUNT.FCY = R.RE.SPEC.ENTRY.DETAIL<RE.CSE.AMOUNT.FCY>

    IF Y.SPEC.AMOUNT GT 0 THEN
        Y.SPEC.AMOUNT.CR=Y.SPEC.AMOUNT
        IF Y.SPEC.TXN.CODE EQ 'RVL' THEN
            Y.REV.AMT<1,1>+=Y.SPEC.AMOUNT
            Y.REV.AMT<1,5>=Y.SAP.COST.CENTER
        END
        ELSE
            Y.NOR.AMT<Y.SP.COMPANY.POS,1>+=Y.SPEC.AMOUNT
        END
    END
    IF Y.SPEC.AMOUNT LT 0 THEN
        Y.SPEC.AMOUNT.DR=Y.SPEC.AMOUNT
        IF Y.SPEC.TXN.CODE EQ 'RVL' THEN

            Y.REV.AMT<1,2>+=Y.SPEC.AMOUNT
            Y.REV.AMT<1,5>=Y.SAP.COST.CENTER
        END
        ELSE
            Y.NOR.AMT<Y.SP.COMPANY.POS,2>+=Y.SPEC.AMOUNT
        END
    END

    IF Y.SPEC.AMOUNT.FCY GT 0 THEN
        Y.SPEC.AMOUNT.FCY.CR=Y.SPEC.AMOUNT.FCY
        IF Y.SPEC.TXN.CODE EQ 'RVL' THEN

            Y.REV.AMT<1,3>+=Y.SPEC.AMOUNT.FCY
        END
        ELSE
            Y.NOR.AMT<Y.SP.COMPANY.POS,3>+=Y.SPEC.AMOUNT.FCY
        END
    END
    IF Y.SPEC.AMOUNT.FCY LT 0 THEN
        Y.SPEC.AMOUNT.FCY.DR=Y.SPEC.AMOUNT.FCY
        IF Y.SPEC.TXN.CODE EQ 'RVL' THEN

            Y.REV.AMT<1,4>+=Y.SPEC.AMOUNT.FCY
        END
        ELSE
            Y.NOR.AMT<Y.SP.COMPANY.POS,4>+=Y.SPEC.AMOUNT.FCY
        END
    END

    Y.FT.OUT.LIST :=Y.SPEC.AMOUNT.DR:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.SPEC.AMOUNT.CR:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.SPEC.AMOUNT.FCY.DR:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.SPEC.AMOUNT.FCY.CR:Y.FLD.DELIM
    Y.FT.OUT.LIST :=R.RE.SPEC.ENTRY.DETAIL<RE.CSE.CONSOL.KEY.TYPE>:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SAP.ACC.NO:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SIB.ACC.NO:Y.FLD.DELIM
    Y.USER.NAME    =R.RE.SPEC.ENTRY.DETAIL<RE.CSE.INPUTTER>
    Y.USER.NAME    =FIELD(Y.USER.NAME,'_',2,1)
    Y.FT.OUT.LIST := Y.USER.NAME

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
PROCESS.CATEG.DETAILS:
*********************
* 20170926 /S
    IF R.CATEG.ENTRY.DETAIL<AC.CAT.BOOKING.DATE> NE PROCESS.DATE THEN
* 20170926 /E
        RETURN
    END
*para of code to get categ entry details
    Y.CATEG.TXN.CODE = R.CATEG.ENTRY.DETAIL<AC.CAT.TRANSACTION.CODE>

    LOCATE Y.CATEG.TXN.CODE IN Y.IGN.TXN.CODES<1,1> SETTING Y.IGN.CATEG.POS THEN
        IF Y.CATEG.TXN.CODE NE '' THEN
            RETURN
        END
    END
    Y.REF      =FIELD(R.CATEG.ENTRY.DETAIL<AC.CAT.TRANS.REFERENCE>,'.',1)
    Y.SYSTEM.ID=R.CATEG.ENTRY.DETAIL<AC.CAT.SYSTEM.ID>
    IF ( Y.REF EQ 'SYSTEM' OR Y.REF EQ 'SESSION' ) AND Y.SYSTEM.ID EQ 'RE' THEN
        RETURN
    END

    Y.TRANS.REFERENCE = R.CATEG.ENTRY.DETAIL<AC.CAT.TRANS.REFERENCE>
    Y.COMPANY.MNE = FIELD(Y.TRANS.REFERENCE,'\',2,1)
    Y.COMPANY.ID  = R.CATEG.ENTRY.DETAIL<AC.CAT.COMPANY.CODE>
    Y.VALUE.DATE  = R.CATEG.ENTRY.DETAIL<AC.CAT.VALUE.DATE>
    IF NOT(Y.VALUE.DATE) THEN
        Y.VALUE.DATE  = R.CATEG.ENTRY.DETAIL<AC.CAT.BOOKING.DATE>
    END
    GOSUB GET.SAP.COST.CENTER
    IF Y.FT.OUT.LIST THEN
        Y.FT.OUT.LIST:=@FM
    END
    Y.FT.OUT.LIST :=  Y.CLOSE.DATE:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.COMPANY.ID:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.VALUE.DATE:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SAP.COST.CENTER:Y.FLD.DELIM
    Y.FT.OUT.LIST :=R.CATEG.ENTRY.DETAIL<AC.CAT.PRODUCT.CATEGORY>:Y.FLD.DELIM
    Y.FT.OUT.LIST :=R.CATEG.ENTRY.DETAIL<AC.CAT.OUR.REFERENCE>:Y.FLD.DELIM
    Y.CUSTOMER.ID = R.CATEG.ENTRY.DETAIL<AC.CAT.CUSTOMER.ID>
    IF NOT(Y.CUSTOMER.ID) THEN
        Y.ACCOUNT.ID=R.CATEG.ENTRY.DETAIL<AC.CAT.OUR.REFERENCE>
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR)
        Y.CUSTOMER.ID=R.ACCOUNT<AC.CUSTOMER>
    END
    Y.FT.OUT.LIST :=Y.CUSTOMER.ID:Y.FLD.DELIM
    IF Y.CUSTOMER.ID THEN
        GOSUB GET.CUSTOMER.DET
    END
    Y.FT.OUT.LIST :=Y.CLIENT.ID:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.CLIENT.TYPE:Y.FLD.DELIM
    Y.CATEG.CURRENCY = R.CATEG.ENTRY.DETAIL<AC.CAT.CURRENCY>
    Y.FT.OUT.LIST := Y.CATEG.CURRENCY:Y.FLD.DELIM
    Y.FT.OUT.LIST :=Y.CATEG.TXN.CODE:Y.FLD.DELIM
    Y.GENERAL.TXN.CODE = Y.CATEG.TXN.CODE
    GOSUB GET.TXN.DESC
    Y.FT.OUT.LIST := Y.TXN.CODE.DESC:Y.FLD.DELIM

    Y.CATEG.AMOUNT = 0
    Y.CATEG.CAT.CODE= R.CATEG.ENTRY.DETAIL<AC.CAT.PL.CATEGORY>
    Y.CATEG.AMOUNT = R.CATEG.ENTRY.DETAIL<AC.CAT.AMOUNT.LCY>
    Y.CATEG.AMOUNT.FCY = R.CATEG.ENTRY.DETAIL<AC.CAT.AMOUNT.FCY>
    Y.REV.CATG.POS=''
    LOCATE Y.CATEG.CAT.CODE IN Y.REVAL.CATEG.LIST SETTING Y.REV.CATG.POS ELSE
        LOCATE Y.CATEG.CAT.CODE IN Y.REVREVAL.CATEG.LIST SETTING Y.REV.CATG.POS ELSE
            Y.REV.CATG.POS=''
        END
    END

    IF Y.CATEG.AMOUNT GT 0 THEN
        Y.CATEG.AMOUNT.CR=Y.CATEG.AMOUNT
        IF Y.REV.CATG.POS THEN

            Y.REV.AMT<1,1>+=Y.CATEG.AMOUNT
            Y.REV.AMT<1,5>=Y.SAP.COST.CENTER
        END
        ELSE
            Y.NOR.AMT<Y.SP.COMPANY.POS,1>+=Y.CATEG.AMOUNT
        END
    END
    IF Y.CATEG.AMOUNT LT 0 THEN
        Y.CATEG.AMOUNT.DR=Y.CATEG.AMOUNT
        IF Y.REV.CATG.POS THEN

            Y.REV.AMT<1,2>+=Y.CATEG.AMOUNT
            Y.REV.AMT<1,5>=Y.SAP.COST.CENTER
        END
        ELSE
            Y.NOR.AMT<Y.SP.COMPANY.POS,2>+=Y.CATEG.AMOUNT
        END
    END
    IF Y.CATEG.AMOUNT.FCY GT 0 THEN
        Y.CATEG.AMOUNT.FCY.CR=Y.CATEG.AMOUNT.FCY
        IF NOT(Y.REV.CATG.POS) THEN
            Y.NOR.AMT<Y.SP.COMPANY.POS,3>+=Y.CATEG.AMOUNT.FCY
        END
    END
    IF Y.CATEG.AMOUNT.FCY LT 0 THEN
        Y.CATEG.AMOUNT.FCY.DR=Y.CATEG.AMOUNT.FCY
        IF NOT(Y.REV.CATG.POS) THEN
            Y.NOR.AMT<Y.SP.COMPANY.POS,4>+=Y.CATEG.AMOUNT.FCY
        END
    END

    Y.EXCH.RATE    = R.CATEG.ENTRY.DETAIL<AC.CAT.EXCHANGE.RATE>
    Y.FT.OUT.LIST := Y.EXCH.RATE : Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.CATEG.AMOUNT.DR  : Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.CATEG.AMOUNT.CR  : Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.CATEG.AMOUNT.FCY.DR : Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.CATEG.AMOUNT.FCY.CR : Y.FLD.DELIM
    Y.FT.OUT.LIST := R.CATEG.ENTRY.DETAIL<AC.CAT.CONSOL.KEY>:'.':R.CATEG.ENTRY.DETAIL<AC.CAT.CRF.TYPE>:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SAP.ACC.NO:Y.FLD.DELIM
    Y.FT.OUT.LIST := Y.SIB.ACC.NO:Y.FLD.DELIM
    Y.USER.NAME=R.CATEG.ENTRY.DETAIL<AC.CAT.INPUTTER>
    Y.USER.NAME    =FIELD(Y.USER.NAME,'_',2,1)
    Y.FT.OUT.LIST := Y.USER.NAME

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.SAP.COST.CENTER:
*******************
    IF Y.COMPANY.MNE NE '' THEN

        LOCATE Y.COMPANY.MNE IN Y.COMPANY.MNE.LIST SETTING Y.COMPANY.MNE.POS THEN
            Y.COMPANY.ID=Y.COMPANY.LIST<Y.COMPANY.MNE.POS>
        END
    END
    LOCATE Y.COMPANY.ID IN Y.COMPANY.LIST SETTING Y.COMPANY.POS THEN
        Y.SAP.COST.CENTER=Y.SAP.COST.CENTER.LIST<Y.COMPANY.POS>
    END

    LOCATE Y.COMPANY.ID IN Y.SP.COMPANY.LIST SETTING Y.SP.COMPANY.POS ELSE
        IF NOT(Y.SP.COMPANY.LIST) THEN
            Y.SP.COMPANY.LIST=Y.COMPANY.ID
        END
        ELSE
            Y.SP.COMPANY.LIST<-1>=Y.COMPANY.ID
        END
        Y.SP.COMPANY.POS=DCOUNT(Y.SP.COMPANY.LIST,@FM)
    END
RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.CUSTOMER.DET:
****************
    Y.CLIENT.TYPE = ''
    Y.CLIENT.ID = ''
    R.CUSTOMER = ''
    CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

    Y.CLIENT.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.TIPO.CL>

    BEGIN CASE

        CASE Y.CLIENT.TYPE EQ 'PERSONA FISICA'

            BEGIN CASE

                CASE R.CUSTOMER<EB.CUS.LEGAL.ID,1> NE ''
                    Y.CLIENT.ID = R.CUSTOMER<EB.CUS.LEGAL.ID,1>

                CASE R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.CIDENT> NE ''
                    Y.CLIENT.ID = FMT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.CIDENT>,'11"0"R')

            END CASE

        CASE Y.CLIENT.TYPE EQ 'PERSONA JURIDICA'

            Y.CLIENT.ID =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.RNC>

        CASE Y.CLIENT.TYPE EQ 'CLIENTE MENOR'

            BEGIN CASE

                CASE R.CUSTOMER<EB.CUS.LEGAL.ID,1> NE ''
                    Y.CLIENT.ID = R.CUSTOMER<EB.CUS.LEGAL.ID,1>

                CASE R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.CIDENT> NE ''
                    Y.CLIENT.ID = FMT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.CIDENT>,'11"0"R')

                CASE R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.ACTANAC> NE ''

                    Y.CLIENT.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.ACTANAC>

                CASE R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.NOUNICO> NE ''

                    Y.CLIENT.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.NOUNICO>

            END CASE

    END CASE

RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.TXN.DESC:
************
    R.TRANSACTION = ''
    TRANSACTION.ERR = ''

    CALL F.READ(FN.TRANSACTION,Y.GENERAL.TXN.CODE,R.TRANSACTION,F.TRANSACTION,TRANSACTION.ERR)
    Y.TXN.CODE.DESC = R.TRANSACTION<AC.TRA.NARRATIVE,1>

RETURN
*--------------------------------------------------------------------------------------------------------
***************
GET.RE.TXN.DESC:
***************

    LOCATE Y.SPEC.TXN.CODE IN Y.SPEC.TXN.CODE.LIST SETTING Y.SPEC.TXN.CODE.POS THEN
        Y.RE.TXN.DESC=Y.SPEC.TXN.DESC.LIST<Y.SPEC.TXN.CODE.POS>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
END
