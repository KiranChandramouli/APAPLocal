* @ValidationCode : MjoyMjQyNTk0Nzg6Q3AxMjUyOjE3MDQ5NjcxNzI2NTc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Jan 2024 15:29:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.STOCK.ENTRY.VALIDATE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.STOCK.ENTRY.VALIDATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Stock details and check in REDO.STOCK.REGISTER for availability

*LINKED WITH       :
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*                  Jeeva
*   16 apr 2011   Balagurunathan        ODR-2010-03-0400          issue fix for TDN4 delivery
*   10.04.2023    Conversion Tool       R22                       Auto Conversion     - FM TO @FM, VM TO @VM, F TO CACHE, ++ TO += 1
*   10.04.2023    Shanmugapriya M       R22                       Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.STOCK.ENTRY
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_F.REDO.CARD.SERIES.PARAM


    GOSUB OPENFILE
    GOSUB PROCESS
RETURN


OPENFILE:
* Opening the Register File

    FN.REDO.STOCK.REGISTER = 'F.REDO.STOCK.REGISTER'
    F.REDO.STOCK.REGISTER  = ''
    CALL OPF(FN.REDO.STOCK.REGISTER,F.REDO.STOCK.REGISTER)

    FN.DAO = 'F.DEPT.ACCT.OFFICER'
    F.DAO = ''
    CALL OPF(FN.DAO,F.DAO)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)


RETURN

PROCESS:

*    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM';* R22 UTILITY AUTO CONVERSION
*    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,'SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR);* R22 UTILITY AUTO CONVERSION
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,IDVAR.1,R.REDO.CARD.SERIES.PARAM,PARAM.ERR);* R22 UTILITY AUTO CONVERSION;* R22 UTILITY AUTO CONVERSION

    CARD.TYPE.PARAM = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
    CARD.SERIES.PARAM = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES>

    CHANGE @VM TO @FM IN CARD.TYPE.PARAM
    CHANGE @VM TO @FM IN CARD.SERIES.PARAM

*Fetching the values entered by the user in
    Y.FETCH.DATE = R.NEW(STK.IN.OUT.DATE)
    IF Y.FETCH.DATE NE TODAY THEN
        AF = STK.IN.OUT.DATE
        ETEXT = "ST-ID.DATE.NOT.EQ.TODAY"
        CALL STORE.END.ERROR
        RETURN
    END

    Y.FETCH.FROM.REG     = R.NEW(STK.FROM.REGISTER)
    Y.FETCH.TO.REG       = R.NEW(STK.TO.REGISTER)

    IF Y.FETCH.FROM.REG EQ Y.FETCH.TO.REG THEN
        AF = STK.TO.REGISTER
        ETEXT = "AC-REGISTER.CANT.SAME"
        CALL STORE.END.ERROR
        RETURN
    END

*Check for Duplidates
    AF.LIST = STK.STOCK.SERIES
    CALL DUP.FLD.SET(AF.LIST)

*Checking the Format of Stock Register
    Y.FORMAT.1 = Y.FETCH.TO.REG[1,4]
    IF Y.FORMAT.1 NE 'CARD' THEN
        ETEXT = "ST-INVALID.FORMAT.ID"
        CALL STORE.END.ERROR
        RETURN
    END
    Y.FORMAT.2 = Y.FETCH.TO.REG[5,1]
    IF Y.FORMAT.2 NE '.' THEN
        ETEXT = "ST-INVALID.FORMAT.ID"
        CALL STORE.END.ERROR
        RETURN
    END
    Y.FORMAT.3 = Y.FETCH.TO.REG[15,1]
    IF Y.FORMAT.3 NE '-' THEN
        ETEXT = "ST-INVALID.FORMAT.ID"
        CALL STORE.END.ERROR
        RETURN
    END

    Y.GET.DAO = FIELD(Y.FETCH.TO.REG,'-',2)
    R.DAO = ''
    CALL CACHE.READ(FN.DAO, Y.GET.DAO, R.DAO, DAO.ERR)               ;** R22 Auto conversion - F TO CACHE

    IF NOT(R.DAO) THEN
        AF = STK.TO.REGISTER
        ETEXT = "AC-INVALID.DEPARTMENT.CODE"
        CALL STORE.END.ERROR
        RETURN
    END

    Y.GET.COMPANY = FIELD(Y.FETCH.TO.REG,'.',2)
    Y.GET.COMPANY = FIELD(Y.GET.COMPANY,'-',1)

    CALL CACHE.READ(FN.COMPANY, Y.GET.COMPANY, R.COMP, COMP.ERR)    ;** R22 Auto conversion - F TO CACHE

    IF NOT(R.COMP) THEN
        AF = STK.TO.REGISTER
        ETEXT = "EB-INVALID.COMP.ID"
        CALL STORE.END.ERROR
        RETURN
    END

    Y.FETCH.STK.SERIES   = R.NEW(STK.STOCK.SERIES)
    Y.FETCH.STK.QUANTITY = R.NEW(STK.STOCK.QUANTITY)

*Read the Register Table and check for the Quantity

    CALL F.READ(FN.REDO.STOCK.REGISTER,Y.FETCH.FROM.REG,R.REDO.STOCK.REGISTER,F.REDO.STOCK.REGISTER,STOCK.ERR)

*Get the series and stock quantity of From Register

    IF R.REDO.STOCK.REGISTER THEN
        Y.REG.STK.SERIES.LIST = R.REDO.STOCK.REGISTER<STK.REG.SERIES.ID>
        Y.REG.STK.QUANTITY    = R.REDO.STOCK.REGISTER<STK.REG.SERIES.BAL>
        GOSUB CHECK.QUANTITY
    END

RETURN


CHECK.QUANTITY:
*Get the count of Series from Register
    Y.STK.SERIES.CNT = DCOUNT(Y.FETCH.STK.SERIES,@VM)

*Locate the series obtained and check for the Stock Quantity
    Y.INIT.CNT = 1
    LOOP
        REMOVE Y.SERIES.ID FROM Y.FETCH.STK.SERIES SETTING Y.SERIES.POS
    WHILE Y.INIT.CNT LE Y.STK.SERIES.CNT

        LOCATE Y.SERIES.ID IN CARD.TYPE.PARAM SETTING PAR.POS THEN
            CARD.TYPE.FETCH = CARD.SERIES.PARAM<PAR.POS>
        END

        LOCATE CARD.TYPE.FETCH IN Y.REG.STK.SERIES.LIST<1,1> SETTING Y.STK.REG.POS THEN
            Y.STK.QUANTITY = Y.FETCH.STK.QUANTITY<1,Y.INIT.CNT>
            Y.REG.QUANTITY = Y.REG.STK.QUANTITY<1,Y.STK.REG.POS>
            IF Y.STK.QUANTITY GT Y.REG.QUANTITY THEN
                ETEXT = "AC-QTY.REGISTER.L.QTY.ENTRY"
                CALL STORE.END.ERROR
            END
        END
        ELSE
            ETEXT = "AC-SERIES.ID.NOT.STOCKED.STOCK.REGISTER"
            CALL STORE.END.ERROR
        END
        Y.INIT.CNT += 1                      ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
