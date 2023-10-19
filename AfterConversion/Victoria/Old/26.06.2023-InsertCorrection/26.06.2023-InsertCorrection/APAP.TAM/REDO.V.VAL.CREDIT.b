* @ValidationCode : MjotODE5MDY4ODQ2OkNwMTI1MjoxNjg3Nzc5Njc4MzAyOnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jun 2023 17:11:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-64</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.CREDIT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CREDIT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as VALIDATION routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536    Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
* 12-JAN-2011        Kavitha.S      ODR-2010-11-0211    Added logic based on B.126 TFS
* 22-jun-2011        Prabhu N       ODR-2010-11-0211    Validation added for closed card account status
* 18-JUL-2011        Joaquin Costa  PACS00077556        Fix validation issues in FT
* 25-AUG-2011        Riyas          PACS00103353        Set common variable to get card id and its used in INPUT Routine to write.
* 16-SEP-2011        Marimuthu S    PACS00123125        Error msg added
*26-06-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*26-06-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $USING APAP.REDOVER
*
*$INSERT I_F.T24.FUND.SERVICES ;*R22 MANUAL CONVERSION
*
    $INSERT I_F.REDO.SUNNEL.CARD.DETAILS
    $INSERT I_F.REDO.SUNNEL.PARAMETER
*
    $INSERT I_REDO.TELLER.PROCESS.COMMON
    $INSERT I_System
*
    IF MESSAGE NE "VAL" THEN
        GOSUB INIT
        GOSUB PROCESS
    END
*
RETURN
*
*----
INIT:
*----
*


    PROCESS.GOAHEAD = "1"
*
    FN.SUNNEL.DETAILS = 'F.REDO.SUNNEL.CARD.DETAILS'
    F.SUNNEL.DETAILS  = ''
*
    FN.REDO.SUNNEL.PARAMETER = 'F.REDO.SUNNEL.PARAMETER'
    F.REDO.SUNNEL.PARAMETER  = ''
*
    CALL OPF(FN.REDO.SUNNEL.PARAMETER,F.REDO.SUNNEL.PARAMETER)
*
    LREF.APP = APPLICATION
    WRSP.ID  = 'SYSTEM'
    LREF.POS = ''
*
    IF APPLICATION NE 'FUNDS.TRANSFER' THEN
        LREF.FIELDS ='L.TT.AC.STATUS':@VM:'L.TT.CR.ACCT.NO':@VM:'L.TT.CR.CARD.NO' ;*R22 MANUAL CONVERSION
    END ELSE
        LREF.FIELDS ='L.FT.AC.STATUS':@VM:'L.FT.CR.ACCT.NO':@VM:'L.FT.CR.CRD.STS' ;*R22 MANUAL CONVERSION
    END
*
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.CARD.ACCT.POS = LREF.POS<1,1>
    Y.FT.CR.STATUS = LREF.POS<1,3>
*
RETURN
*
*-------
PROCESS:
*-------
*
    WLOC.REF.POS = ""
*
    BEGIN CASE
        CASE APPLICATION EQ 'TELLER'
            Y.CARD.POS     = LREF.POS<1,3>
            WLOC.REF.POS   = TT.TE.LOCAL.REF
            Y.PREV.CARD.NO = R.NEW.LAST(TT.TE.LOCAL.REF)<1,Y.CARD.POS>
            Y.NEW.CARD.NO  = COMI
            IF Y.PREV.CARD.NO NE Y.NEW.CARD.NO THEN
                Y.ARRAY   ='BUSCAR_TARJETA_CUENTA.1'
            END ELSE
                PROCESS.GOAHEAD = ""
            END
*
        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            WLOC.REF.POS  = FT.LOCAL.REF
            Y.ARRAY       = 'BUSCAR_TARJETA_CUENTA.FT'
*
        CASE APPLICATION EQ 'T24.FUND.SERVICES'
*R22 MANUAL CONVERSION
*            WLOC.REF.POS = TFS.LOCAL.REF
            Y.TXN.CODES  = R.NEW(TFS.TRANSACTION)
            CHANGE @VM TO @FM IN Y.TXN.CODES ;*R22 MANUAL CONVERSION
            LOCATE 'CREDCARDPAYMENT' IN Y.TXN.CODES<1> SETTING Y.TXN.POS THEN
                Y.ARRAY = 'BUSCAR_TARJETA_TFS'
            END ELSE
                PROCESS.GOAHEAD = ""
            END

    END CASE
*
    IF PROCESS.GOAHEAD THEN
*CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
*R22 MANUAL CONVERSION
        APAP.REDOVER.redoVWrapSunnel(Y.ARRAY)
        GOSUB CHECK.STATUS
    END
*
    IF PROCESS.GOAHEAD THEN
        GOSUB TYPE.UPDATE
        COMI = COMI[1,6]:'******':COMI[13,4]
    END
*
RETURN
*
*------------
CHECK.STATUS:
*------------
*
    Y.CARD.ACCT.ST = R.NEW(WLOC.REF.POS)<1,Y.CARD.ACCT.POS>
*
    CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,WRSP.ID,R.REDO.SUNNEL.PARAMETER,ERR)
    Y.STATUS<2> = R.REDO.SUNNEL.PARAMETER<SP.CLOSED.STATUS>

    IF Y.CARD.ACCT.ST EQ Y.STATUS<2> THEN
        ETEXT="EB-REDO.CARD.CLOSED"
        CALL STORE.END.ERROR
        PROCESS.GOAHEAD = ""
    END

** PACS00123125 -s
    Y.CR.STATUS = R.NEW(FT.LOCAL.REF)<1,Y.FT.CR.STATUS>
    Y.CR.ACCT.STATUS = R.NEW(FT.LOCAL.REF)<1,Y.CARD.ACCT.POS>
    IF Y.CR.STATUS EQ 'CANCELADA' THEN
        AF = FT.LOCAL.REF
        AV = Y.FT.CR.STATUS
        ETEXT = 'EB-CARD.STATUS.CANCEL'
        CALL STORE.END.ERROR
    END
    IF Y.CR.ACCT.STATUS EQ 'CANCELADA' THEN
        AF = FT.LOCAL.REF
        AV = Y.CARD.ACCT.POS
        ETEXT = 'EB-CARD.ACCT.STATUS.CANCEL'
        CALL STORE.END.ERROR
    END

** PACS00123125 -e

*
RETURN
*
*----------
TYPE.UPDATE:
*-----------
*
*****************
* Report 35 Change
*
    Y.ACCT.POS = LREF.POS<1,2>
    Y.ACCT.NO  = R.NEW(WLOC.REF.POS)<1,Y.ACCT.POS>
*
    CALL F.READ(FN.SUNNEL.DETAILS,Y.ACCT.NO,R.SUNNEL.DETAILS,F.SUNNEL.DETAILS,SUNNEL.ERR)
    IF NOT(R.SUNNEL.DETAILS) THEN
        Y.GET.CARD.NO = COMI
*PACS00103353-S
        CALL System.setVariable("CURRENT.CARD.NO",Y.GET.CARD.NO)
*PACS00103353-E
*CALL REDO.GET.CARD.TYPE(Y.GET.CARD.NO,Y.ACCT.NO,Y.CARD.TYPE)
*R22 MANUAL CONVERSION
        APAP.TAM.redoGetCardType(Y.GET.CARD.NO,Y.ACCT.NO,Y.CARD.TYPE)
        R.SUNNEL.DETAILS<SUN.CARD.TYPE> = Y.CARD.TYPE
        CALL F.WRITE(FN.SUNNEL.DETAILS,Y.ACCT.NO,R.SUNNEL.DETAILS)
    END
*
*Report 35 End
******************
*
RETURN
*
END
