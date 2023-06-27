* @ValidationCode : Mjo1NjQ2Njk4OTQ6Q3AxMjUyOjE2ODY2NzM5OTE1MzU6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:03:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
*-----------------------------------------------------------------------------
* <Rating>-55</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.S.FC.DEF.DISB
*-----------------------------------------------------------------------------
* Developer    : wmeza@temenos.com
* Date         : 2012-03-23
* Description  : The purpose for this routine is to display the proper values on Monto Cargo when any Tipo Cargo Desembolso has been choosen on Creacion Prestamo sin Garantia screen
* Modified by:    :
* Date            :
* Notes           :
*-----------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
* Out :
*-----------------------------------------------------------------------------
* 20-APR-2012     S.MARIMUTHU    PACS00146445    Charge calculation for LEVEL and BAND types
* 12-Jun-2023  Santosh      Manual R22 conversion   New argument added in AA.CALCULATE.TIER.AMOUNT
*-----------------------------------------------------------------------------
* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT

* </region>



*EXCECUTE ONLY IF PRESS HOT FIELD


    Y.PROPERTY = COMI

    Y.CHAR.DESC = R.NEW(REDO.FC.CHARG.DISC)

    IF Y.CHAR.DESC THEN
        IF MESSAGE EQ 'VAL' THEN
            AF = REDO.FC.CHARG.DISC
            CALL DUP
        END ELSE
            LOCATE Y.PROPERTY IN Y.CHAR.DESC<1,1> SETTING PS.PRP THEN
                ETEXT = 'EB-DUP.CHG.PROP'
                AF = REDO.FC.CHARG.DISC
                CALL STORE.END.ERROR
            END
        END
    END

    VAR.HOT = OFS$HOT.FIELD
    IF LEN(VAR.HOT) EQ 0 THEN
        RETURN
    END

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

* <region name="INITIALISE">
INITIALISE:
    Y.COD.PROD = R.NEW(REDO.FC.PRODUCT)
    FN.AA.PRODUCT.CATALOG = 'F.AA.PRODUCT.CATALOG'
    F.AA.PRODUCT.CATALOG = ''
    R.AA.PRODUCT.CATALOG = ''
    FN.AA.PRD.DES.CHARGE = 'F.AA.PRD.DES.CHARGE'
    F.AA.PRD.DES.CHARGE = ''
    R.AA.PRD.DES.CHARGE = ''
    TIER.BASE.AMOUNT = '' ;*Manual R22 conversion

    CALL OPF (FN.AA.PRODUCT.CATALOG, F.AA.PRODUCT.CATALOG)
    CALL OPF (FN.AA.PRD.DES.CHARGE, F.AA.PRD.DES.CHARGE)

RETURN
* </region>

* <region name="PROCESS">
PROCESS:


    SELECT.STATEMENT = 'SELECT ':FN.AA.PRODUCT.CATALOG:' WITH @ID LIKE ':Y.COD.PROD:'... BY-DSND @ID'
    AA.PRODUCT.CATALOG.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,AA.PRODUCT.CATALOG.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    REMOVE AA.PRODUCT.CATALOG.ID FROM AA.PRODUCT.CATALOG.LIST SETTING AA.PRODUCT.CATALOG.MARK
    R.PRODUCT.CATALOG = ''
    Y.ERR = ''
    CALL F.READ(FN.AA.PRODUCT.CATALOG,AA.PRODUCT.CATALOG.ID,R.AA.PRODUCT.CATALOG,F.AA.PRODUCT.CATALOG,YERR)
    IF YERR THEN
        E = YERR
        RETURN
    END
    LOCATE Y.PROPERTY IN R.AA.PRODUCT.CATALOG<AA.PRD.PROPERTY, 1> SETTING POS.Y THEN
        Y.PROPERTY = R.AA.PRODUCT.CATALOG<AA.PRD.PRD.PROPERTY, POS.Y, 1>

        SELECT.STATEMENT = 'SELECT ':FN.AA.PRD.DES.CHARGE:' WITH @ID LIKE ':Y.PROPERTY:'-... BY-DSND @ID'
        FN.AA.PRD.DES.CHARGE.LIST = ''
        LIST.NAME = ''
        SELECTED = ''
        SYSTEM.RETURN.CODE = ''
        CALL EB.READLIST(SELECT.STATEMENT,AA.PRD.DES.CHARGE.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
        REMOVE AA.PRD.DES.CHARGE.ID FROM AA.PRD.DES.CHARGE.LIST SETTING AA.PRD.DES.CHARGE.MARK
        R.AA.PRD.DES.CHARGE = ''
        Y.ERR = ''
        CALL F.READ(FN.AA.PRD.DES.CHARGE,AA.PRD.DES.CHARGE.ID,R.CHARGE.RECORD,F.AA.PRD.DES.CHARGE,YERR)
        IF YERR THEN
            E = YERR
            RETURN
        END
        Y.MONTO.CARGO = 0
        IF R.CHARGE.RECORD<AA.CHG.CHARGE.TYPE> EQ 'FIJO' OR R.CHARGE.RECORD<AA.CHG.CHARGE.TYPE> EQ 'FIXED' THEN
            Y.MONTO.CARGO = R.CHARGE.RECORD<AA.CHG.FIXED.AMOUNT>
            R.NEW(REDO.FC.CHARG.AMOUNT)<1,AV> = Y.MONTO.CARGO
        END ELSE
            GOSUB PROCESS.LEVEL.BAND
            R.NEW(REDO.FC.CHARG.AMOUNT)<1,AV> = CHARGE.AMOUNT
        END

    END

RETURN

PROCESS.LEVEL.BAND:

    TIER.GROUP.TYPE = R.CHARGE.RECORD<AA.CHG.TIER.GROUPS>
    TIER.TYPE = R.CHARGE.RECORD<AA.CHG.CALC.TIER.TYPE>
    TIER.MAX.AMOUNT = R.CHARGE.RECORD<AA.CHG.TIER.MAX.CHARGE>
    TIER.MIN.AMOUNT = R.CHARGE.RECORD<AA.CHG.TIER.MIN.CHARGE>
    TIER.AMOUNT = R.CHARGE.RECORD<AA.CHG.TIER.AMOUNT>
    CALC.TYPE = R.CHARGE.RECORD<AA.CHG.CALC.TYPE>

    NO.OF.CALC.TYPES = DCOUNT(CALC.TYPE,@VM)

    FLG = ''
    LOOP
    WHILE NO.OF.CALC.TYPES GT 0 DO
        FLG += 1
        IF CALC.TYPE<1,FLG> = "PERCENTAGE" THEN
            CALC.VALUE<1,FLG> = R.CHARGE.RECORD<AA.CHG.CHARGE.RATE,FLG>
        END ELSE
            CALC.VALUE<1,FLG> = R.CHARGE.RECORD<AA.CHG.CHG.AMOUNT,FLG>
        END
        NO.OF.CALC.TYPES -= 1
    REPEAT

    ARR.BASE.AMOUNT = R.NEW(REDO.FC.AMOUNT)
*TUS AA PARAM CHANGES - 20161024
*   CALL AA.CALCULATE.TIER.AMOUNT(TIER.GROUP.TYPE, TIER.TYPE, CALC.TYPE, CALC.VALUE, TIER.MAX.AMOUNT, TIER.MIN.AMOUNT, TIER.AMOUNT, ARR.BASE.AMOUNT, CHARGE.AMOUNT, RET.ERROR)
*   CALL AA.CALCULATE.TIER.AMOUNT(TIER.GROUP.TYPE, TIER.TYPE, CALC.TYPE, CALC.VALUE, TIER.MAX.AMOUNT, TIER.MIN.AMOUNT, TIER.AMOUNT, ARR.BASE.AMOUNT, CHARGE.AMOUNT, CHARGE.CALC.DETAILS, RET.ERROR)
    CALL AA.CALCULATE.TIER.AMOUNT(TIER.GROUP.TYPE, TIER.TYPE, CALC.TYPE, CALC.VALUE, TIRE.MAX.AMOUNT, TIRE.MIN.AMOUNT, TIER.AMOUNT, ARR.BASE.AMOUNT, TIER.BASE.AMOUNT, CHARGE.AMOUNT, CHARGE.CALC.DETAILS, RET.ERROR)   ;*Manual R22 conversion - New argument TIER.BASE.AMOUNT added
*TUS END

RETURN

* </region>

END
