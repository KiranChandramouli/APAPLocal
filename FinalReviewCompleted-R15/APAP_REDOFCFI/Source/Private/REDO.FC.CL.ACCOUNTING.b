* @ValidationCode : Mjo4Mzg1Mzg1Mzc6Q3AxMjUyOjE2ODA2NzE1NjEzMDA6SVRTUzotMTotMTo0OTM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:42:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 493
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.CL.ACCOUNTING(ACTION)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 15.06.2011
* Description  : Process OFS Messages
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       11.07.2011      lpazmino          CR.180         Initial Version
* 1.1       26.12.2012      MGUDINO           CR.180         Ammended version
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
* Input/Output:
* None/None
*
* Dependencies: NA
*
*-----------------------------------------------------------------------------
*
* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.COLLATERAL
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY

    $INSERT I_F.ACCOUNT

    $INSERT I_F.REDO.COLLATERAL.PARAMETER
* </region>
*
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="INIT" description="Initialise">
INIT:
    Y.PGM = 'COLLATERAL'

    Y.BASE.ENTRY = ''
    Y.ENTRY      = ''
    Y.ENTRY.REC  = ''

    Y.CL.CUSTOMER = ''
    Y.ACC.OFFICER = ''
    Y.DEPART.CODE = ''

    Y.CL.AMOUNT        = ''
    Y.CR.CATEGORY.CODE = ''
    Y.DB.CATEGORY.CODE = ''
    Y.CR.INT.ACCOUNT   = ''
    Y.DB.INT.ACCOUNT   = ''
    Y.CR.TRX           = ''
    Y.DB.TRX           = ''

    Y.COLLATERAL = ID.NEW

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    R.CUSTOMER  = ''

    FN.REDO.COLLATERAL.PARAMETER = 'F.REDO.COLLATERAL.PARAMETER'
    F.REDO.COLLATERAL.PARAMETER  = ''
    R.REDO.COLLATERAL.PARAMETER  = ''

    FN.COLLATERAL= 'F.COLLATERAL$HIS'
    F.COLLATERAL= ''
    R.COLLATERAL= ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''


    Y.VALIDATE.ACCOUNTS = 1
    Y.ERR = ''
* To permit interact with contingents accouts in the actual application
    COMMON/CONTINGENT.APPS/APP.LIST
    YPOS = ""
    LOCATE APPLICATION IN APP.LIST<1> SETTING YPOS ELSE
        INS APPLICATION BEFORE APP.LIST<YPOS>
    END
* PACS00307565 - S
    Y.CO.GLV.NEW = ''
    Y.CO.GLV.OLD = ''
* PACS00307565 - E
RETURN
* </region>

* <region name="OPEN.FILES" description="Open Files">
OPEN.FILES:
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
    CALL OPF(FN.REDO.COLLATERAL.PARAMETER, F.REDO.COLLATERAL.PARAMETER)
    CALL OPF(FN.COLLATERAL, F.COLLATERAL)
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

RETURN
* </region>

* <region name="PROCESS" description="Main Process">
PROCESS:

    BEGIN CASE
        CASE ACTION EQ 'NEW'
* Nuevo COLLATERAL
            GOSUB REG.NEW.COLLATERAL

        CASE ACTION EQ 'REVA'
* Revaluacion del COLLATERAL
            GOSUB REG.REVA.COLLATERAL

        CASE ACTION EQ 'CANCEL'
* Cancelacion del COLLATERAL
            GOSUB REG.CANCEL.COLLATERAL
    END CASE

*      GOSUB APPLY.ACC.ENTRY

RETURN
* </region>

* <region name="DEF.BASE.ENTRY" description="Create the common entry fields">
DEF.BASE.ENTRY:
    GOSUB OBTAIN.CUSTOMER.DATA

    Y.BASE.ENTRY<AC.STE.COMPANY.CODE>     = ID.COMPANY
    Y.BASE.ENTRY<AC.STE.SYSTEM.ID>        = "AC"
    Y.BASE.ENTRY<AC.STE.BOOKING.DATE>     = TODAY
    Y.BASE.ENTRY<AC.STE.EXPOSURE.DATE>    = TODAY
    Y.BASE.ENTRY<AC.STE.CUSTOMER.ID>      = Y.CL.CUSTOMER
    Y.BASE.ENTRY<AC.STE.POSITION.TYPE>    = "TR"
    Y.BASE.ENTRY<AC.STE.CURRENCY.MARKET>  = "1"
    Y.BASE.ENTRY<AC.STE.CURRENCY>         = R.NEW(COLL.CURRENCY)
    Y.BASE.ENTRY<AC.STE.ACCOUNT.OFFICER>  = Y.ACC.OFFICER
    Y.BASE.ENTRY<AC.STE.DEPARTMENT.CODE>  = Y.DEPART.CODE
    Y.BASE.ENTRY<AC.STE.THEIR.REFERENCE>  = ID.NEW
    Y.BASE.ENTRY<AC.STE.TRANS.REFERENCE>  = ID.NEW
    Y.BASE.ENTRY<AC.STE.OUR.REFERENCE>    = ID.NEW

RETURN
* </region>

* <region name="CREATE.CR.ENTRY" description="Create the Credit Entry">
CREATE.CR.ENTRY:
    Y.ENTRY = Y.BASE.ENTRY

    Y.ENTRY<AC.STE.VALUE.DATE>       = TODAY
    Y.ENTRY<AC.STE.TRANSACTION.CODE> = Y.CR.TRX
    Y.ENTRY<AC.STE.PRODUCT.CATEGORY> = Y.CR.CATEGORY.CODE
    Y.ENTRY<AC.STE.PL.CATEGORY>      = ''
    Y.ENTRY<AC.STE.ACCOUNT.NUMBER>   = Y.CR.INT.ACCOUNT

    IF R.NEW(COLL.CURRENCY) EQ LCCY THEN
        Y.ENTRY<AC.STE.AMOUNT.LCY>    = Y.CL.AMOUNT
        Y.ENTRY<AC.STE.AMOUNT.FCY>    = ''
    END ELSE
        Y.ENTRY<AC.STE.AMOUNT.FCY>    = Y.CL.AMOUNT
        Y.ENTRY<AC.STE.AMOUNT.LCY>    = ''
    END

    Y.ENTRY.REC<-1> = LOWER(Y.ENTRY)

RETURN
* </region>

* <region name="CREATE.DB.ENTRY" description="Create the Debit Entry">
CREATE.DB.ENTRY:
    Y.ENTRY = Y.BASE.ENTRY

    Y.ENTRY<AC.STE.VALUE.DATE>       = TODAY
    Y.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DB.TRX
    Y.ENTRY<AC.STE.PRODUCT.CATEGORY> = Y.DB.CATEGORY.CODE
    Y.ENTRY<AC.STE.PL.CATEGORY>      = ''
    Y.ENTRY<AC.STE.ACCOUNT.NUMBER>   = Y.DB.INT.ACCOUNT

    IF R.NEW(COLL.CURRENCY) EQ LCCY THEN
        Y.ENTRY<AC.STE.AMOUNT.LCY>    = Y.CL.AMOUNT * -1
        Y.ENTRY<AC.STE.AMOUNT.FCY>    = ''
    END ELSE
        Y.ENTRY<AC.STE.AMOUNT.FCY>    =  Y.CL.AMOUNT * -1
        Y.ENTRY<AC.STE.AMOUNT.LCY>    = ''
    END

    Y.ENTRY.REC<-1> = LOWER(Y.ENTRY)

RETURN
* </region>

* <region name="APPLY.ACC.ENTRY" description="Applies the account entry">
APPLY.ACC.ENTRY:
    CALL EB.ACCOUNTING("AC","SAO",Y.ENTRY.REC,"")

RETURN
* </region>

REG.CANCEL.COLLATERAL:
*
    GOSUB OBTAIN.ACC.DETAILS
*
    GOSUB DEF.BASE.ENTRY
*
    Y.DB.INT.ACCOUNT.CAN = Y.CR.INT.ACCOUNT
    Y.CR.INT.ACCOUNT.CAN = Y.DB.INT.ACCOUNT
    Y.DB.INT.ACCOUNT = Y.DB.INT.ACCOUNT.CAN
    Y.CR.INT.ACCOUNT = Y.CR.INT.ACCOUNT.CAN

    GOSUB CREATE.CR.ENTRY
    GOSUB CREATE.DB.ENTRY

    GOSUB APPLY.ACC.ENTRY

    Y.DB.INT.ACCOUNT = Y.CR.INT.ACCOUNT.CAN
    Y.CR.INT.ACCOUNT = Y.DB.INT.ACCOUNT.CAN


RETURN
* </region>

REG.REVA.COLLATERAL:
* PROCESS TO MAKE DE CANCELATION
*
* PACS00307565 - S
    Y.CO.GLV.NEW = R.NEW(COLL.GEN.LEDGER.VALUE)
    Y.CO.GLV.OLD = R.OLD(COLL.GEN.LEDGER.VALUE)
    IF Y.CO.GLV.OLD NE "" AND Y.CO.GLV.OLD EQ Y.CO.GLV.NEW THEN
        RETURN
    END
* PACS00307565 - E
    GOSUB OBTAIN.ACC.DETAILS

    Y.CL.AMOUNT.LAST = 0
    Y.CURR.NO = R.OLD(COLL.CURR.NO)
    Y.COLLATERAL = Y.COLLATERAL:';':Y.CURR.NO
    CALL F.READ(FN.COLLATERAL,Y.COLLATERAL,R.COLLATERAL,F.COLLATERAL,Y.ERR)
    IF NOT(Y.ERR) THEN
        Y.GEN.LEDGER.VALUE = R.COLLATERAL<COLL.GEN.LEDGER.VALUE>
        Y.CL.AMOUNT.LAST = Y.GEN.LEDGER.VALUE * -1
    END

* PROCESS TO GET THE LAST VALUE

    Y.CL.AMOUNT = R.NEW(COLL.GEN.LEDGER.VALUE)

* PROCESS TO MAKE THE NEW ACCOUNTING WITH THE NEW VALUE

    Y.CL.AMOUNT += Y.CL.AMOUNT.LAST ;* R22 AUTO CONVERSION

    GOSUB DEF.BASE.ENTRY
    GOSUB CREATE.CR.ENTRY
    GOSUB CREATE.DB.ENTRY
    GOSUB APPLY.ACC.ENTRY

RETURN
* </region>

* <region name="REG.NEW.COLLATERAL" description="Register new Collateral">
REG.NEW.COLLATERAL:
    GOSUB OBTAIN.ACC.DETAILS

    GOSUB DEF.BASE.ENTRY
    GOSUB CREATE.CR.ENTRY
    GOSUB CREATE.DB.ENTRY
    GOSUB APPLY.ACC.ENTRY

RETURN
* </region>

* <region name="OBTAIN.CUSTOMER.DATA" description="Obtain Customer Data">
OBTAIN.CUSTOMER.DATA:
    Y.CL.CUSTOMER = ID.NEW[".",1,1]

    CALL F.READ(FN.CUSTOMER,Y.CL.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.ERR)
    IF NOT(Y.ERR) THEN
        Y.ACC.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
        Y.DEPART.CODE = R.CUSTOMER<EB.CUS.DEPT.CODE>
    END

RETURN
* </region>

* <region name="OBTAIN.ACC.DETAILS" description="Obtain Accounting Info">
OBTAIN.ACC.DETAILS:
    Y.COLL.CODE = R.NEW(COLL.COLLATERAL.CODE)
    Y.CL.AMOUNT = R.NEW(COLL.GEN.LEDGER.VALUE)

    CALL CACHE.READ(FN.REDO.COLLATERAL.PARAMETER,Y.COLL.CODE,R.REDO.COLLATERAL.PARAMETER,Y.ERR)

* Obtener la informacion de acuerdo al tipo de COLLATERAL
    Y.CL.TYPE.NUM = DCOUNT(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.COLLATERAL.TYPE>,@VM)
    I.VAR = 1
    LOOP
    WHILE I.VAR LE Y.CL.TYPE.NUM
        Y.CL.TYPE = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.COLLATERAL.TYPE>,@VM,I.VAR)
        IF Y.CL.TYPE EQ R.NEW(COLL.COLLATERAL.TYPE) THEN
            Y.CR.CATEGORY.CODE = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CR.CATEGORY.CODE>,@VM,I.VAR)
            Y.DB.CATEGORY.CODE = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.DB.CATEGORY.CODE>,@VM,I.VAR)

            Y.CR.TRX = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CR.TRX.CODE>,@VM,I.VAR)
            Y.DB.TRX = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.DB.TRX.CODE>,@VM,I.VAR)

            Y.CY.NUM = DCOUNT(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CURRENCY,I.VAR>,@SM)
            GOSUB  OBTAIN.ACC.DETAILS2

        END
        I.VAR += 1 ;* R22 AUTO CONVERSION
    REPEAT

    Y.ACCOUNT = Y.CR.INT.ACCOUNT
    Y.ERR = ''
    R.ACCOUNT.DB = ''
    R.ACCOUNT.CR = ''

RETURN
OBTAIN.ACC.DETAILS2:
*
    J.VAR = 1
    LOOP
    WHILE J.VAR LE Y.CY.NUM
        Y.CY = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CURRENCY,I.VAR>,@SM,J.VAR)

        IF Y.CY EQ R.NEW(COLL.CURRENCY) THEN
            Y.CR.INT.ACCOUNT   = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CR.INT.ACCOUNT,I.VAR>,@SM,J.VAR)
            Y.DB.INT.ACCOUNT   = R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.DB.INT.ACCOUNT,I.VAR,J.VAR>
        END
        J.VAR += 1
    REPEAT
RETURN
* </region>

END
