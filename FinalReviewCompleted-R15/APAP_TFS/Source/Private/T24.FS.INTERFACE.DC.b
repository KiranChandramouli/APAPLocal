* @ValidationCode : MjotMTMzODI2MDI2MTpDcDEyNTI6MTY5ODc1MDY3MzM5NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>281</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.INTERFACE.DC(MV.NO,OFS.BODY)
*
* Subroutine to Create OFS Message for FT, based on the value from
* R.NEW.
*
* MV.NO - The Multi Value Number or the Line Number to be processed
*
*=======================================================================
*
* Modification History:
*
* 09/22/04    - Sathish PS
*               New Development
*
* 15 DEC 2006 - Sesh V.S
*             - Code amended so that the amount taken to create DC should
*             - be the one as in TFS record (Only future exposures)
*
* 08/05/09    - Anitha.S
*               included Anti Money Laundering Gap for Multi Line Teller
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion           USPLATFORM.BP File Removed, CALL routine format modified
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion

    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.TRANSACTION
    $INSERT I_F.COMPANY
    $INCLUDE I_F.T24.FUND.SERVICES ;*R22 Manual Conversion
    $INCLUDE I_F.TFS.PARAMETER ;*R22 Manual Conversion
    $INCLUDE I_F.TFS.TRANSACTION ;*R22 Manual Conversion
    
    
 
    GOSUB INIT
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*========================================================================
PROCESS:

    IF R.NEW(TFS.CURRENCY)<1,MV.NO> EQ LCCY THEN
        AMOUNT.LCY = R.NEW(TFS.AMOUNT)<1,MV.NO>
        YCCY = ''
        AMOUNT.FCY = ''
    END ELSE
        AMOUNT.LCY = ''
        YCCY = R.NEW(TFS.CURRENCY)<1,MV.NO>
        AMOUNT.FCY = R.NEW(TFS.AMOUNT)<1,MV.NO>
    END
*
    IF R.NEW(TFS.REVERSAL.MARK)<1,MV.NO> EQ 'R' THEN
        IF R.NEW(TFS.DC.REVERSE.MARK)<1,MV.NO> EQ 'R' THEN
            REVERSAL.MARK = ''
        END ELSE
            REVERSAL.MARK = 'R'
        END
    END ELSE
        IF R.NEW(TFS.DC.REVERSE.MARK)<1,MV.NO> EQ 'R' THEN
            REVERSAL.MARK = 'R'
        END
    END

    IF REVERSAL.MARK THEN
        DR.SIGN = 'C'
        CR.SIGN = 'D'
    END ELSE
        REVERSAL.MARK = ''
        DR.SIGN = 'D'
        CR.SIGN = 'C'
    END
*
    IF R.NEW(TFS.REVERSAL.MARK)<1,MV.NO> THEN
        GOSUB BUILD.DC.LEGS.FROM.ENTRIES
    END ELSE
        GOSUB BUILD.DC.LEGS.FROM.T24.FS
    END

RETURN
*----------------------------------------------------------------------
BUILD.DC.LEGS.FROM.T24.FS:

    GOSUB BUILD.CR.DC.LEG

    OFS.BODY.1 = OFS.BODY
    OFS.BODY = ''

    GOSUB BUILD.DR.DC.LEG

    OFS.BODY.2 = OFS.BODY
    OFS.BODY<1> = OFS.BODY.1
    OFS.BODY<2> = OFS.BODY.2

RETURN
*----------------------------------------------------------------------
BUILD.DR.DC.LEG:

    GOSUB LEG.INITIALISE

    AC.ID = R.NEW(TFS.ACCOUNT.DR)<1,MV.NO>
    IF AC.ID[1,2] EQ 'PL' THEN
        PRODUCT.CATEG = R.NEW(TFS.PRODUCT.CATEG)<1,MV.NO>
        CUS.NO = R.NEW(TFS.CUSTOMER.NO)<1,MV.NO>
        ACC.OFF = R.NEW(TFS.ACCOUNT.OFFICER)<1,MV.NO>
    END ELSE
        PRODUCT.CATEG = ''
    END
    TXN.CODE = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.DC.TXN.CODE.DR>
    SIGN = DR.SIGN
    IF REVERSAL.MARK EQ 'R' THEN EXP.DATE = R.NEW(TFS.DR.EXP.DATE)<1,MV.NO>
    VALUE.DATE = R.NEW(TFS.DR.VALUE.DATE)<1,MV.NO>
    CHQ.TYPE = R.NEW(TFS.CHQ.TYPE)<1,MV.NO>
    CHQ.NUMBER = R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO>

    GOSUB BUILD.DC.LEG

RETURN
*----------------------------------------------------------------------
BUILD.CR.DC.LEG:

    GOSUB LEG.INITIALISE

    AC.ID = R.NEW(TFS.ACCOUNT.CR)<1,MV.NO>
    IF AC.ID[1,2] EQ 'PL' THEN
        PRODUCT.CATEG = R.NEW(TFS.PRODUCT.CATEG)<1,MV.NO>
        CUS.NO = R.NEW(TFS.CUSTOMER.NO)<1,MV.NO>
        ACC.OFF = R.NEW(TFS.ACCOUNT.OFFICER)<1,MV.NO>
    END ELSE
        PRODUCT.CATEG = ''
    END
    TXN.CODE = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.DC.TXN.CODE.CR>
    SIGN = CR.SIGN
    EXP.DATE = R.NEW(TFS.CR.EXP.DATE)<1,MV.NO>    ;* Just in case we have a future exposure
    VALUE.DATE = R.NEW(TFS.CR.VALUE.DATE)<1,MV.NO>

    GOSUB BUILD.DC.LEG

RETURN
*----------------------------------------------------------------------
BUILD.DC.LEGS.FROM.ENTRIES:

* We will be here ONLY if this is a REVERSAL of a Line processed by us, initially

    UL.STMT.NOS = R.NEW(TFS.UL.STMT.NO)<1,MV.NO>
    LOOP
        REMOVE ENTRY.ID FROM UL.STMT.NOS SETTING NEXT.ENTRY.ID.POS
    WHILE ENTRY.ID : NEXT.ENTRY.ID.POS DO
        ENTRY.PREFIX = ENTRY.ID[1,3]
        ENTRY.ID[1,3] = ''
        ENTRY.COMP = ENTRY.ID['\',2,1]
        ENTRY.ID = ENTRY.ID['\',1,1]
        CALL F.READV(FN.COMP,ENTRY.COMP,ENTRY.COMP.MNE,EB.COM.MNEMONIC,F.COMP,ERR.COMP)
        BEGIN CASE
            CASE ENTRY.PREFIX EQ 'SE-'
*FN.SE = 'F':ENTRY.COMP.MNE:'.STMT.ENTRY' ;  *ANITHA S 23/6/2009
                FN.SE = 'F.STMT.ENTRY' ;
                F.SE = '' ; CALL OPF(FN.SE,F.SE)
                CALL F.READ(FN.SE,ENTRY.ID,R.ENTRY,F.SE,ERR.SE)

            CASE ENTRY.PREFIX EQ 'CE-'
                FN.CE = 'F':ENTRY.COMP.MNE:'.CATEG.ENTRY' ; F.CE = '' ; CALL OPF(FN.CE,F.CE)
                CALL F.READ(FN.CE,ENTRY.ID,R.ENTRY,F.CE,ERR.CE)
        END CASE

        IF R.ENTRY THEN
            IF R.ENTRY<AC.STE.RECORD.STATUS> NE 'REVE' THEN

                GOSUB LEG.INITIALISE
                GOSUB GET.ENTRY.DETAILS
                GOSUB BUILD.DC.LEG

                TEMP.OFS.BODY<-1> = OFS.BODY
                OFS.BODY = ''
            END
        END

    REPEAT

    IF TEMP.OFS.BODY THEN OFS.BODY = TEMP.OFS.BODY

RETURN
*----------------------------------------------------------------------
BUILD.DC.LEG:

    IF AC.ID[1,2] EQ 'PL' THEN
        PL.CATEG = AC.ID[5]
        AC.ID = ''
    END ELSE
        PL.CATEG = ''
        PRODUCT.CATEG = ''
    END
*
    OFS.BODY = 'SIGN:1:1=' : SIGN :','
    IF AC.ID THEN
        OFS.BODY := 'ACCOUNT.NUMBER:1:1=' : AC.ID :','
    END
    IF AMOUNT.LCY THEN
        OFS.BODY := 'AMOUNT.LCY:1:1=' : AMOUNT.LCY :','
    END
    OFS.BODY := 'TRANSACTION.CODE:1:1=' : TXN.CODE :','
    OFS.BODY := 'THEIR.REFERENCE:1:1=' : ID.NEW :','
    IF OUR.NARR THEN
        OFS.BODY := 'NARRATIVE:1:1=' : OUR.NARR :','
    END ELSE
        IF R.NEW(TFS.NARRATIVE)<1,MV.NO> THEN
            OFS.BODY := 'NARRATIVE:1:1=' : R.NEW(TFS.NARRATIVE)<1,MV.NO> :','
        END
    END
    IF PL.CATEG THEN
        OFS.BODY := 'PL.CATEGORY:1:1=' : PL.CATEG :','
        OFS.BODY := 'PRODUCT.CATEGORY:1:1=' : PRODUCT.CATEG :','
        IF CUS.NO THEN
            OFS.BODY := 'CUSTOMER.ID:1:1=': CUS.NO :','
        END ELSE
            OFS.BODY := 'ACCOUNT.OFFICER:1:1=' : ACC.OFF :','
        END
    END
    IF VALUE.DATE THEN
        OFS.BODY := 'VALUE.DATE:1:1=' : VALUE.DATE :','
    END
    IF YCCY THEN
        OFS.BODY := 'CURRENCY:1:1=' : YCCY :','
        OFS.BODY := 'AMOUNT.FCY:1:1=' : AMOUNT.FCY :','
        OFS.BODY := 'EXCHANGE.RATE:1:1=' : EXCH.RATE :','
    END
    IF R.NEW(TFS.OUR.REFERENCE)<1,MV.NO> THEN
        OFS.BODY := 'OUR.REFERENCE:1:1=' : R.NEW(TFS.OUR.REFERENCE)<1,MV.NO> :','
    END
    IF REVERSAL.MARK THEN
        OFS.BODY := 'REVERSAL.MARKER:1:1=' : REVERSAL.MARK :','
    END
    IF EXP.DATE THEN
        OFS.BODY := 'EXPOSURE.DATE:1:1=' : EXP.DATE :','
    END
    CALL F.READ(FN.TXN,TXN.CODE,R.TXN,F.TXN,ERR.TXN)
    IF R.TXN<AC.TRA.CHEQUE.IND> EQ 'Y' THEN
        IF NOT(CHQ.NUMBER) THEN CHQ.NUMBER = R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO>
        OFS.BODY := 'CHEQUE.NUMBER:1:1=' : CHQ.NUMBER :','
        IF CHQ.TYPE THEN
            OFS.BODY := 'CHEQ.TYPE:1:1=' : CHQ.TYPE :','
        END
    END

    OFS.BODY := 'T24.FS.REF:1:1=' : ID.NEW :','

*S Anitha 08/05/09 Anti Money Laundering Gap for Multi Line Teller
    OFS.BDY=''
*   CALL GET.LOC.REF.UPDATE(OFS.BDY)
    APAP.TFS.getLocRefUpdate(OFS.BDY) ;*R22 Manual Conversion
 
    OFS.BODY:= OFS.BDY
*E Anitha 08/05/09 Anti Money Laundering Gap for Multi Line Teller

RETURN
*-----------------------------------------------------------------------
GET.ENTRY.DETAILS:
*
* This subroutine will manipulate TXN.CODE, AMOUNT & ACCOUNTs to be part of the
* DC leg, based on REVERSAL.MARK in the ORIGINAL Entry
*
* Assume,
* a) Credit Transaction Code : 51
* b) Debit Transaction Code  : 1
* c) The original txn        :
*
* A/C 23779 SIGN=D TRANSACTION=51 AMT=10 REVERSAL.MARK=R --> Result : Debit of 10 from 23779
* A/C 23884 SIGN=C TRANSACTION=1 AMT=10 REVERSAL.MARK=R  --> Result : Credit of 10 to 23884
*
* If we have to reverse these two entries, then it is a Reversal of a Reversal and it has to be
*
* A/C 23779 SIGN=C TRANSACTION=1 AMT=10 REVERSAL.MARK=R  --> Result : Credit of 10 to 23779
* A/C 23884 SIGN=D TRANSACTION=51 AMT=10 REVERSAL.MARK=R --> Result : Debit of 10 from 23884
*
* Or it could also be
*
* A/C 23779 SIGN=C TRANSACTION=51 AMT=10 --> Result : Credit of 10 to 23779
* A/C 23884 SIGN=D TRANSACTION=1 AMT=10 --> Result : Debit of 10 from 23884
*
* This is controlled by the field DC.REV.ON.REV - RETAIN.MARKER or NULL respectively
*
    AC.ID = '' ; TXN.CODE = '' ; SIGN = '' ; EXP.DATE = '' ; VALUE.DATE = ''
    IF ENTRY.PREFIX EQ 'SE-' THEN
        AC.ID = R.ENTRY<AC.STE.ACCOUNT.NUMBER>
        PRODUCT.CATEG = ''
    END ELSE
        AC.ID = 'PL': R.ENTRY<AC.CAT.PL.CATEGORY>
        PRODUCT.CATEG = R.ENTRY<AC.CAT.PRODUCT.CATEGORY>
    END
*
    IF R.ENTRY<AC.STE.AMOUNT.FCY> THEN  ;* Same field no. for both SE & CE
        AMOUNT.LCY = ''
        YCCY = R.ENTRY<AC.STE.CURRENCY> ;* Same field no. for both SE & CE
        AMOUNT.FCY = R.ENTRY<AC.STE.AMOUNT.FCY>   ;* Same field no. for both SE & CE
        CHK.AMT = AMOUNT.FCY
        AMOUNT.FCY = ABS(AMOUNT.FCY)
        EXCH.RATE = R.ENTRY<AC.STE.EXCHANGE.RATE>
    END ELSE
        AMOUNT.LCY = R.ENTRY<AC.STE.AMOUNT.LCY>   ;* Same field no. for both SE & CE
        CHK.AMT = AMOUNT.LCY
        AMOUNT.LCY = ABS(R.NEW(TFS.AMOUNT)<1,MV.NO>)        ;* 15 DEC 2006 - Sesh V.S - /S
        YCCY = ''
        AMOUNT.FCY = ''
    END
*
    GOSUB DETERMINE.SIGN.AND.TXN.CODE

*
    EXP.DATE = R.ENTRY<AC.STE.EXPOSURE.DATE>      ;* Same field no. for both SE & CE
    IF EXP.DATE LT TODAY THEN
        IF TXN.TYPE EQ 'CR' THEN
            EXP.DATE = R.NEW(TFS.DR.EXP.DATE)<1,MV.NO>
        END ELSE
            EXP.DATE = R.NEW(TFS.CR.EXP.DATE)<1,MV.NO>
        END
    END
    VALUE.DATE = R.ENTRY<AC.STE.VALUE.DATE>       ;* Same field no. for both SE & CE
    OUR.NARR = R.NEW(TFS.UNDERLYING)<1,MV.NO>
    ACC.OFF = R.ENTRY<AC.STE.ACCOUNT.OFFICER>
    CUS.NO = R.ENTRY<AC.STE.CUSTOMER.ID>
    CHQ.TYPE = R.ENTRY<AC.STE.CHQ.TYPE>
    CHQ.NUMBER = R.ENTRY<AC.STE.CHEQUE.NUMBER>

RETURN
*--------------------------------------------------------------------------
LEG.INITIALISE:

    AC.ID = '' ; TXN.CODE = '' ; SIGN = '' ; EXP.DATE = '' ; VALUE.DATE = ''
    EXCH.RATE = '' ; POS.TYPE = ''
    OUR.NARR = '' ; CUS.NO = '' ;  ACC.OFF = '' ; CHQ.TYPE = '' ; CHQ.NUMBER = ''

RETURN
*--------------------------------------------------------------------------
DETERMINE.SIGN.AND.TXN.CODE:

    TXN.CODE = R.ENTRY<AC.STE.TRANSACTION.CODE>   ;* Same field no. for both SE & CE
    CALL F.READ(FN.TXN,TXN.CODE,R.TXN,F.TXN,ERR.TXN)

    BEGIN CASE

        CASE TFS$R.TFS.PAR<TFS.PAR.DC.REV.ON.REV> EQ 'RETAIN.MARKER'
            TXN.TYPE = ''
            BEGIN CASE
                CASE CHK.AMT GE 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> NE ''   ;* Reversal of a Reversal
                    SIGN = CR.SIGN
                    REVERSAL.MARK = R.ENTRY<AC.STE.REVERSAL.MARKER> ;* REVERSAL.MARK could have been set to '' above.. So reset it.
                    TXN.TYPE = 'DR'

                CASE CHK.AMT GE 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> EQ ''   ;* Remember, we are Reversing our line in this subroutine
                    SIGN = CR.SIGN
                    TXN.TYPE = 'CR'

                CASE CHK.AMT LT 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> NE ''   ;* Reversal of a Reversal
                    SIGN = DR.SIGN
                    REVERSAL.MARK = R.ENTRY<AC.STE.REVERSAL.MARKER> ;* REVERSAL.MARK could have been set to '' above.. So reset it.
                    TXN.TYPE = 'CR'

                CASE CHK.AMT LT 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> EQ ''
                    SIGN = DR.SIGN
                    TXN.TYPE = 'DR'
            END CASE
*
            IF R.TXN<AC.TRA.DATA.CAPTURE> EQ 'Y' THEN
                IF R.ENTRY<AC.STE.REVERSAL.MARKER> NE '' THEN
*
* Reversal of Reversal is only possible for DC transaction and the Account in the DC Leg HAS to be
* one of ACCOUNT.DR or ACCOUNT.CR. There can't be a third a/c involved.
* So, swap the Accounts in the entries
*
                    BEGIN CASE
                        CASE AC.ID EQ R.NEW(TFS.ACCOUNT.CR)<1,MV.NO>
                            AC.ID = R.NEW(TFS.ACCOUNT.DR)<1,MV.NO>
                        CASE AC.ID EQ R.NEW(TFS.ACCOUNT.DR)<1,MV.NO>
                            AC.ID = R.NEW(TFS.ACCOUNT.CR)<1,MV.NO>
                    END CASE
                END
            END ELSE
* For others, assign the appropriate Txn code from TFS.TRANSACTION
                BEGIN CASE
                    CASE TXN.TYPE EQ 'CR'
                        TXN.CODE = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.DC.TXN.CODE.CR>
                    CASE TXN.TYPE EQ 'DR'
                        TXN.CODE = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.DC.TXN.CODE.DR>
                END CASE
            END

        CASE TFS$R.TFS.PAR<TFS.PAR.DC.REV.ON.REV> EQ ''

            BEGIN CASE
                CASE CHK.AMT GE 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> NE ''
                    SIGN = DR.SIGN    ;* Remember, we are Reversing the original Entry.
                    TXN.TYPE = 'DR'

                CASE CHK.AMT LT 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> NE ''
                    SIGN = CR.SIGN
                    TXN.TYPE = 'CR'

                CASE CHK.AMT GE 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> EQ ''
                    SIGN = CR.SIGN
                    TXN.TYPE = 'CR'

                CASE CHK.AMT LT 0 AND R.ENTRY<AC.STE.REVERSAL.MARKER> EQ ''
                    SIGN = DR.SIGN
                    TXN.TYPE = 'DR'
            END CASE
*
            IF R.TXN<AC.TRA.DATA.CAPTURE> EQ 'Y' THEN ;* NO problem. We are good
            END ELSE
* For others, assign the appropriate Txn code from TFS.TRANSACTION
                BEGIN CASE
                    CASE TXN.TYPE EQ 'CR'
                        TXN.CODE = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.DC.TXN.CODE.CR>
                    CASE TXN.TYPE EQ 'DR'
                        TXN.CODE = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.DC.TXN.CODE.DR>
                END CASE
            END

    END CASE

RETURN
*--------------------------------------------------------------------------
INIT:

    PROCESS.GOAHEAD = 1
    OFS.BODY = ''

    FN.AC = 'F.ACCOUNT' ; F.AC = ''
    FN.SE = 'F.STMT.ENTRY' ; F.SE = ''
    FN.CE = 'F.CATEG.ENTRY' ; F.CE = ''
    FN.TXN = 'F.TRANSACTION' ; F.TXN = ''
    FN.COMP = 'F.COMPANY' ; F.COMP = ''

RETURN
*========================================================================
END




