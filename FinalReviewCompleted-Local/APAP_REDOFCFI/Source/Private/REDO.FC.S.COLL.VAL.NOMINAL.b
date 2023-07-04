* @ValidationCode : MjotMTk0MzI1ODk1NDpDcDEyNTI6MTY4MDc4MzY2Nzc4NDpJVFNTOi0xOi0xOjE1NDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 154
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.COLL.VAL.NOMINAL
*------------------------------------------------------------------------------------------------------------------
* Developer    : mgudino@temenos.com
* Date         : 2011-06-13
* Description  : This routine its in charge to validate Insurance and Policys
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
*      P.FIELD.NAME              Name of field that we have tu validate
*      R.NEW                     Common Variable with current Application Info
* Out :
*      P.MESSAGE                  Message to send by pharent call.
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-06-13    Marcelo Gudiño   First Version
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
*
    $INSERT I_F.LIMIT
    $INSERT I_F.COLLATERAL.RIGHT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.OFS.SOURCE
*
    $INSERT I_RAPID.APP.DEV.COMMON
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_F.REDO.FC.POL.TYPE.CLASS
*
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS.VALIDATE
    GOSUB PROCESS.DEFAULT
RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------
*
    FN.LOCKING = 'F.LOCKING'
    F.LOCKING = ''
    Y.ID.POL = 'POL'
    R.LOCKING = ''
    YERR = ''
    LOCKING.ID = 'F.REDO.FC.POLNUM'

    FN.AA.PRD.CAT.TERM.AMOUNT = 'FBNK.AA.PRD.CAT.TERM.AMOUNT'
    F.AA.PRD.CAT.TERM.AMOUNT = ''

    Y.COLLATERAL.CODE = R.NEW(REDO.FC.SEC.NO.STATE.DI)
    Y.TASA = R.NEW(REDO.FC.FIXED.RATE)
    Y.TIPO.REV.TASA = R.NEW(REDO.FC.TYPE.RATE.REV)
    Y.COLL.CLASS =  R.NEW(REDO.FC.SEC.CLASSIFY.DI)
    Y.ARR.PRODUCT =  R.NEW(REDO.FC.PRODUCT)
    Y.ARR.CURRENCY =  R.NEW(REDO.FC.LOAN.CURRENCY)
    Y.ARR.AMOUNT =  R.NEW(REDO.FC.AMOUNT)

RETURN
*------------------------------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------------------------------

*   Paragraph that open files
*

    CALL OPF(FN.LOCKING,F.LOCKING)

    CALL OPF(FN.AA.PRD.CAT.TERM.AMOUNT, F.AA.PRD.CAT.TERM.AMOUNT)

* -----------------------------------------
RETURN
*------------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------------------
PROCESS.VALIDATE:
*
*------------------------------------------------------------------------------------------------------------------
*

    IF  Y.COLL.CLASS EQ 151 OR Y.COLL.CLASS EQ 152 OR Y.COLL.CLASS EQ 153 THEN
*    POBLAR VALOR NOMINAL DE LA GARANTIA
*TUS AA Changes 20161021
*    Y.ID.ARR.PRD.CAT.TERM.AMOUNT = Y.ARR.PRODUCT:'COMMITMENT':Y.ARR.CURRENCY
        Y.ID.ARR.PRD.CAT.TERM.AMOUNT = Y.ARR.PRODUCT:'-':'COMMITMENT':'-':Y.ARR.CURRENCY:'...'
*TUS END
        SELECT.STATEMENT = 'SELECT ':FN.AA.PRD.CAT.TERM.AMOUNT: 'WITH @ID LIKE ':Y.ID.ARR.PRD.CAT.TERM.AMOUNT:' BY-DSND ID.COMP.5'
        AA.PRD.CAT.TERM.AMOUNT.LIST = ''
        LIST.NAME = ''
        SELECTED = ''
        SYSTEM.RETURN.CODE = ''
        Y.ID.AA.PRD = ''
        CALL EB.READLIST(SELECT.STATEMENT,AA.PRD.CAT.TERM.AMOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
        LOOP
            REMOVE Y.ID.AA.PRD FROM AA.PRD.CAT.TERM.AMOUNT.LIST SETTING POS
        WHILE Y.ID.AA.PRD:POS
            CALL CACHE.READ(F.AA.PRD.CAT.TERM.AMOUNT, Y.ID.AA.PRD, R.ARR.PRD.CAT.TERM.AMOUNT, Y.ERR)
            IF Y.ERR NE '' THEN
                P.MESSAGE = 'ERROR AL LEER ': Y.ID.ARR.PRD.CAT.TERM.AMOUNT:' EN LA TABLA ARR.PRD.CAT.TERM.AMOUNT'
                RETURN
            END
            BREAK
        REPEAT
        LOC.REF.APPLICATION = 'AA.PRD.CAT.TERM.AMOUNT'
        LOC.REF.FIELDS = 'L.AA.RISK.PER'
        LOC.REF.POS = ''
        CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
        TXN.REF.ID.POS = LOC.REF.POS<1,1>
        Y.VAL.AA.RISK.PER = R.ARR.PRD.CAT.TERM.AMOUNT<1,TXN.REF.ID.POS>
        Y.VAL.NOMINAL.COLL = Y.VAL.AA.RISK.PER * Y.ARR.AMOUNT
        R.NEW(REDO.FC.SEC.VALUE.DI) = Y.VAL.NOMINAL.COLL

* POBLAR VALOR ADMISIBLE DEL REA

    END
*




RETURN
*------------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------------------
PROCESS.DEFAULT:
*
*------------------------------------------------------------------------------------------------------------------
*
* SETEAR VALORES POR DEFECTO REDO.FC.TYPE.OF.SEC.DI
    IF Y.COLLATERAL.CODE EQ 150  THEN
        R.NEW(REDO.FC.TYPE.RATE.REV) = 'BACK to BACK'
    END

    IF Y.COLLATERAL.CODE EQ 150 AND Y.TASA NE ''  THEN
        P.MESSAGE = 'DATO NO PUEDE SER INGRESADO POR EL USUARIO.'
        RETURN
    END


RETURN
*------------------------------------------------------------------------------------------------------------------
END
