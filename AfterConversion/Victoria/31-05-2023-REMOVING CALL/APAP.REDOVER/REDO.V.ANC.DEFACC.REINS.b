* @ValidationCode : MjoxNDY5OTM1OTQ3OkNwMTI1MjoxNjg1NTM2MDA2NzkzOnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:56:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ANC.DEFACC.REINS
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.ANC.DEFACC.REINS
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is auto new content routine attached to CURRENCY.1 field in
* TELLER. Based on REDO.V.ANC.DEF.ACCOUNT
* TELLER,REDO.REINSTATE

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*08.04.2013  H GANESH     ODR-2009-12-0285  INITIAL CREATION
*07.05.2013  Arundev      PACS00273377     4780 Cadena 31590 VER-TELLER,REDO.REINSTATE-1-eang (Issues Criticos)
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_System
    $USING APAP.TAM

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.TELLER.HIS='F.TELLER$HIS'
    F.TELLER.HIS=''
    R.TELLER = ''

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)
*
    LREF.APP   = 'TELLER'
    LREF.FIELD = 'L.TT.BENEFICIAR':@VM:'L.TT.BEN.LIST':@VM:'L.TT.CONCEPT':@VM:'L.NEXT.VERSION'
    LREF.POS   = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    BENEFICIARY.POS = LREF.POS<1,1>
    BENEFICLIST.POS = LREF.POS<1,2>
    CONCEPTO.POS    = LREF.POS<1,3>
    NEXTVERSION.POS = LREF.POS<1,4>
*
RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    GOSUB GET.SYSTEM.VARS
    Y.HIST.ID=FIELD(WTM.CURR.ID,"*",2)
    Y.HIST.ID = FIELD(Y.HIST.ID,";",1)
    IF Y.HIST.ID NE '' THEN
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.HIST.ID,R.TELLER,TT.ERR)
        CALL F.READ(FN.TELLER.USER,OPERATOR,R.TEL.US,F.TELLER.USER,TEL.ERR)
        GOSUB PROCEED.NEXT.PARA
    END
*
RETURN
*
*-----------
GET.SYSTEM.VARS:
*
    WVAR.NAMES    = "CURRENT.ID"
    WVAR.VAL      = ""
    WPOS.X        = 0
*
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    LOOP
        REMOVE WWVAR FROM WVAR.NAMES SETTING WVAR.POS
    WHILE WWVAR : WVAR.POS DO
        WPOS.X += 1
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WVAR.VAL<WPOS.X> = U.VARVALS<YPOS.VAR>
        END ELSE
            WVAR.VAL<WPOS.X> = WWVAR
        END
    REPEAT
*
    WTM.CURR.ID = WVAR.VAL<1>
*
RETURN
*
*-----------
PROCEED.NEXT.PARA:
*
    IF R.TELLER THEN
*
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
        APAP.TAM.redoHandleCommTaxFields();* R22 Manual conversion
        R.NEW(TT.TE.TELLER.ID.1)    = R.TEL.US
        R.NEW(TT.TE.CURRENCY.1)     = R.TELLER<TT.TE.CURRENCY.1>
        R.NEW(TT.TE.CHEQUE.NUMBER)  = R.TELLER<TT.TE.CHEQUE.NUMBER>
        R.NEW(TT.TE.NARRATIVE.1)    = R.TELLER<TT.TE.NARRATIVE.1>
        R.NEW(TT.TE.ACCOUNT.1)      = R.TELLER<TT.TE.ACCOUNT.1>
        R.NEW(TT.TE.ACCOUNT.2)      = R.TELLER<TT.TE.ACCOUNT.2>
        R.NEW(TT.TE.AMOUNT.LOCAL.2) = R.TELLER<TT.TE.AMOUNT.LOCAL.2>
        R.NEW(TT.TE.CURRENCY.2)     = R.TELLER<TT.TE.CURRENCY.2>
        R.NEW(TT.TE.TELLER.ID.2)    = R.TEL.US
        R.NEW(TT.TE.LOCAL.REF)<1,BENEFICIARY.POS> = R.TELLER<TT.TE.LOCAL.REF><1,BENEFICIARY.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,BENEFICLIST.POS> = R.TELLER<TT.TE.LOCAL.REF><1,BENEFICLIST.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,CONCEPTO.POS>    = R.TELLER<TT.TE.LOCAL.REF><1,CONCEPTO.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,CONCEPTO.POS>    = R.TELLER<TT.TE.LOCAL.REF><1,CONCEPTO.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,NEXTVERSION.POS> = R.TELLER<TT.TE.LOCAL.REF><1,NEXTVERSION.POS>
*PACS00273377-start
        R.NEW(TT.TE.VALUE.DATE.1) = TODAY
        R.NEW(TT.TE.VALUE.DATE.2) = TODAY
        R.NEW(TT.TE.EXPOSURE.DATE.2) = TODAY          ;*DR.CR.MARKER is DEBIT and exposure date should be null for debit entries
*PACS00273377-end
    END ELSE
*
        GOSUB COND.ELSE.PARAT
*
    END
*
RETURN
*------------
COND.ELSE.PARAT:
*
    Y.HIST.ID = FIELD(Y.HIST.ID,";",1)
    CALL F.READ(FN.TELLER,Y.HIST.ID,R.TELLER,F.TELLER,TEL.ERRR)
    IF R.TELLER NE "" THEN
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
        APAP.TAM.redoHandleCommTaxFields();* R22 Manual conversion
        R.NEW(TT.TE.TELLER.ID.1)    = R.TEL.US
        R.NEW(TT.TE.CURRENCY.1)     = R.TELLER<TT.TE.CURRENCY.1>
        R.NEW(TT.TE.ACCOUNT.1)      = R.TELLER<TT.TE.ACCOUNT.1>
        R.NEW(TT.TE.ACCOUNT.2)      = R.TELLER<TT.TE.ACCOUNT.2>
        R.NEW(TT.TE.CHEQUE.NUMBER)  = R.TELLER<TT.TE.CHEQUE.NUMBER>
        R.NEW(TT.TE.NARRATIVE.1)    = R.TELLER<TT.TE.NARRATIVE.1>
        R.NEW(TT.TE.AMOUNT.LOCAL.2) = R.TELLER<TT.TE.AMOUNT.LOCAL.2>
        R.NEW(TT.TE.CURRENCY.2)     = R.TELLER<TT.TE.CURRENCY.2>
        R.NEW(TT.TE.TELLER.ID.2)    = R.TEL.US
        R.NEW(TT.TE.LOCAL.REF)<1,BENEFICIARY.POS> = R.TELLER<TT.TE.LOCAL.REF><1,BENEFICIARY.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,BENEFICLIST.POS> = R.TELLER<TT.TE.LOCAL.REF><1,BENEFICLIST.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,CONCEPTO.POS>    = R.TELLER<TT.TE.LOCAL.REF><1,CONCEPTO.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,NEXTVERSION.POS> = R.TELLER<TT.TE.LOCAL.REF><1,NEXTVERSION.POS>
*PACS00273377-start
        R.NEW(TT.TE.VALUE.DATE.1) = TODAY
        R.NEW(TT.TE.VALUE.DATE.2) = TODAY
        R.NEW(TT.TE.EXPOSURE.DATE.2) = TODAY          ;*DR.CR.MARKER is DEBIT and exposure date should be null for debit entries
*PACS00273377-end
    END
*
RETURN
*
END
