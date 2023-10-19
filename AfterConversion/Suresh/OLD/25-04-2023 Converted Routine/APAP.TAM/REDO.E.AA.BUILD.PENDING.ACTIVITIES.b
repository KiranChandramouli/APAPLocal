* @ValidationCode : MjoyNTgwNTM1OkNwMTI1MjoxNjgyNDIwNTU4MTc2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:32:38
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
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       FM TO @FM, VM TO @VM, SM TO @SM
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.AA.BUILD.PENDING.ACTIVITIES(RET.VAL)
************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_DAS.AA.ARRANGEMENT.ACTIVITY
*
    COMMON/AAHIST/RET.ARR
*****

    GOSUB INITIALISE
    GOSUB GET.DETAILS
*
RETURN
**************************
INITIALISE:

    RET.VAL = ''
    RET.ARR = ''
    HOLD.REQD = ''
*
    LOCATE 'ARR.ID' IN ENQ.SELECTION<2,1> SETTING ARR.POS THEN
        ARR.ID = ENQ.SELECTION<4,ARR.POS>
    END
*
    FN.AA.ACT.HIST = 'F.AA.ACTIVITY.HISTORY'
    FV.AA.ACT.HIST = ''
    CALL OPF(FN.AA.ACT.HIST,FV.AA.ACT.HIST)
*
    R.AA.ACT.HIST = ''
    CALL F.READ(FN.AA.ACT.HIST,ARR.ID,R.AA.ACT.HIST,FV.AA.ACT.HIST,ERR.MSG)
*
    FN.AA.ACTIVITY.HISTORY.HIST = "F.AA.ACTIVITY.HISTORY.HIST"
    F.AA.ACTIVITY.HISTORY.HIST = ""
    CALL OPF(FN.AA.ACTIVITY.HISTORY.HIST, F.AA.ACTIVITY.HISTORY.HIST)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY$NAU'
    FV.AAA = ''
    CALL OPF(FN.AAA, FV.AAA)

    FT.VALID = '' ; FT.INSTALLED = '' ; COMP.FT = '' ; ERR.MSG = ''
    CALL EB.VAL.PRODUCT('FT',FT.VALID,FT.INSTALLED,COMP.FT,ERR.MSG)

    IF FT.VALID AND FT.INSTALLED AND COMP.FT THEN
        FN.FT = 'F.FUNDS.TRANSFER$NAU'
        FV.FT = ''
        CALL OPF(FN.FT,FV.FT)
    END

    TT.VALID = '' ; TT.INSTALLED = '' ; COMP.TT = '' ; ERR.MSG = ''
    CALL EB.VAL.PRODUCT('TT',TT.VALID,TT.INSTALLED,COMP.TT,ERR.MSG)

    IF TT.VALID AND TT.INSTALLED AND COMP.TT THEN
        FN.TT = 'F.TELLER$NAU'
        FV.TT = ''
        CALL OPF(FN.TT,FV.TT)
    END

    LC.VALID = '' ; LC.INSTALLED = '' ; COMP.LC = '' ; ERR.MSG = ''
    CALL EB.VAL.PRODUCT('LC',LC.VALID,LC.INSTALLED,COMP.LC,ERR.MSG)

    IF LC.VALID AND LC.INSTALLED AND COMP.LC THEN
        FN.LC = 'F.LETTER.OF.CREDIT$NAU'
        FV.LC = ''
        CALL OPF(FN.LC,FV.LC)
    END

    ST.VALID = '' ; ST.INSTALLED = '' ; COMP.ST = '' ; ERR.MSG = ''
    CALL EB.VAL.PRODUCT('ST', ST.VALID, ST.INSTALLED, COMP.ST, ERR.MSG)

    IF ST.VALID AND ST.INSTALLED AND COMP.ST THEN
        FN.ST = 'F.PAYMENT.STOP$NAU'
        FV.ST = ''
        CALL OPF(FN.ST,FV.ST)
    END

    LD.VALID = '' ; LD.INSTALLED = ''; COMP.LD = '' ERR.MSG = ''
    CALL EB.VAL.PRODUCT('LD', LD.VALID, LD.INSTALLED, COMP.LD, ERR.MSG)

    IF LD.VALID AND LD.INSTALLED AND COMP.LD THEN
        FN.LD = 'F.LD.LOANS.AND.DEPOSITS$NAU'
        FV.LD = ''
        CALL OPF(FN.LD,FV.LD)
    END

    PD.VALID = '' ; PD.INSTALLED = ''; COMP.PD = '' ERR.MSG = ''
    CALL EB.VAL.PRODUCT('PD', PD.VALID, PD.INSTALLED, COMP.PD, ERR.MSG)

    IF PD.VALID AND PD.INSTALLED AND COMP.PD THEN
        FN.PD = 'F.PD.PAYMENT.DUE$NAU'
        FV.PD = ''
        CALL OPF(FN.PD,FV.PD)
    END

    MD.VALID = '' ; MD.INSTALLED = '' ; COMP.MD = '' ; ERR.MSG = ''
    CALL EB.VAL.PRODUCT('MD', MD.VALID, MD.INSTALLED, COMP.MD, ERR.MSG)

    IF MD.VALID AND MD.INSTALLED AND COMP.MD THEN
        FN.MD = 'F.MD.DEAL$NAU'
        FV.MD = ''
        CALL OPF(FN.MD,FV.MD)
    END

    LOCATE 'INCLUDE.HOLD' IN ENQ.SELECTION<2,1> SETTING HOLD.POS THEN ;* Point the include.hold value for getting IHLD activities
        HOLD.REQD = ENQ.SELECTION<4,HOLD.POS>
    END

    IF HOLD.REQD THEN
        TABLE.NAME = "AA.ARRANGEMENT.ACTIVITY"
        THE.LIST = DAS$STATUS.HOLD
        THE.ARGS = ARR.ID
        TABLE.SUFFIX = '$NAU'

        CALL DAS(TABLE.NAME,THE.LIST,THE.ARGS,TABLE.SUFFIX)

        ID.LIST = ''
        NO.REC = ''

        ID.LIST = THE.LIST
    END

    NO.REC = DCOUNT(ID.LIST,@FM)

*
RETURN
**************************
GET.DETAILS:
*
    NO.OF.DT = DCOUNT(R.AA.ACT.HIST<AA.AH.EFFECTIVE.DATE>,@VM)
    UPD.CNT = 1
    GOSUB BUILD.ACTIVITIES
    GOSUB GET.AA.ACT.HIST.HIST.RECS
*
    IF ID.LIST THEN ;*Build details from AA.ARRANGEMENT.ACTIVITY
        FOR LOOP.CNT = 1 TO NO.REC
            AAA.REC = ''
            CALL F.READ(FN.AAA, ID.LIST<LOOP.CNT>, AAA.REC, FV.AAA, READ.ERR)
            RET.ARR<1,-1> = AAA.REC<AA.ARR.ACT.EFFECTIVE.DATE>
            RET.ARR<2,-1> = ID.LIST<LOOP.CNT>
            RET.ARR<3,-1> = AAA.REC<AA.ARR.ACT.ACTIVITY>
            RET.ARR<4,-1> = ''
            RET.ARR<5,-1> = AAA.REC<AA.ARR.ACT.TXN.AMOUNT>
            RET.ARR<6,-1> = AAA.REC<AA.ARR.ACT.RECORD.STATUS>
            RET.ARR<7,-1> = AAA.REC<AA.ARR.ACT.INITIATION.TYPE>
            RET.ARR<8,-1> = AAA.REC<AA.ARR.ACT.TXN.CONTRACT.ID>
            RET.VAL<-1> = UPD.CNT
            UPD.CNT += 1
        NEXT LOOP.CNT
    END
*
    IF RET.ARR ELSE
        RET.ARR = "NO.RECORD.SELECTED"
        RET.VAL<-1> = UPD.CNT
    END
*
RETURN
*-----------------------------------------------------------------------------
*** <region name= BUILD.ACTIVITIES>
*** <desc>Build activites list </desc>
BUILD.ACTIVITIES:

    FOR CNT.DT = 1 TO NO.OF.DT
        EFF.DT = R.AA.ACT.HIST<AA.AH.EFFECTIVE.DATE,CNT.DT>
        NO.OF.ACT = DCOUNT(R.AA.ACT.HIST<AA.AH.ACTIVITY.REF,CNT.DT>,@SM)
        FOR CNT.ACT = 1 TO NO.OF.ACT
            IF R.AA.ACT.HIST<AA.AH.ACT.STATUS,CNT.DT,CNT.ACT> MATCHES 'UNAUTH':@VM:'REVERSE':@VM:'UNAUTH-CHG' THEN
* Checks which activity to display in enquiry when reverse replay happens.
                GOSUB REV.REPLAY.CHK
                IF ALLOW.ACTIVITY.PROC.FLAG THEN
                    RETURN.TXN.ID = ''
                    BEGIN CASE
                        CASE R.AA.ACT.HIST<AA.AH.INITIATION,CNT.DT,CNT.ACT> EQ "USER"
                            GOSUB BUILD.RET.ARRAY     ;*Build Return Array
                        CASE R.AA.ACT.HIST<AA.AH.INITIATION,CNT.DT,CNT.ACT> EQ "TRANSACTION"
                            GOSUB GET.TXN.SYS.ID      ;*Get Transaction System Id
                            GOSUB BUILD.RET.ARRAY
                    END CASE
                END
            END
        NEXT CNT.ACT
    NEXT CNT.DT
RETURN
*-----------------------------------------------------------------------------
*** <region name= GET.AA.ACT.HIST.HIST.RECS>
*** <desc>Get Files from AA.ACTIVITY.HISTORY.HIST </desc>
GET.AA.ACT.HIST.HIST.RECS:

    R.AA.ACT.HIST = ''
    CALL AA.READ.ACTIVITY.HISTORY(ARR.ID, "", "", R.AA.ACT.HIST)
    ARC.IDS = R.AA.ACT.HIST<AA.AH.ARC.ID>
    NO.OF.ACR.IDS = DCOUNT(ARC.IDS,@VM)

    FOR CNT.ARC.ID = 1 TO NO.OF.ACR.IDS
        ARC.ID = ARC.IDS<1,CNT.ARC.ID>
        CALL F.READ(FN.AA.ACTIVITY.HISTORY.HIST, ARC.ID, R.AA.ACT.HIST, F.AA.ACTIVITY.HISTORY.HIST, ERR.AA.ACTIVITY.HISTORY.HIST)
        EFF.DATES = R.AA.ACT.HIST<AA.AH.EFFECTIVE.DATE>
        NO.OF.DT = DCOUNT(EFF.DATES,@VM)
        GOSUB BUILD.ACTIVITIES
    NEXT CNT.ARC.ID
RETURN
*-----------------------------------------------------------------------------
*** <region name= GET.TXN.SYS.ID>
*** <desc>Get Transaction System Id </desc>
GET.TXN.SYS.ID:

    BEGIN CASE
        CASE R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ "FT" AND FT.VALID AND FT.INSTALLED AND COMP.FT
            CALL F.READ(FN.FT,R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>,R.FT,FV.FT,FT.ERR)
            IF R.FT THEN
                RETURN.TXN.ID = 1
            END
        CASE R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ "TT" AND TT.VALID AND TT.INSTALLED AND COMP.TT
            CALL F.READ(FN.TT,R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>,R.TT,FV.TT,TT.ERR)
            IF R.TT THEN
                RETURN.TXN.ID = 1
            END
        CASE R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ "LCM" AND LC.VALID AND LC.INSTALLED AND COMP.LC
            CALL F.READ(FN.LC,R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>,R.LC,FV.LC,LC.ERR)
            IF R.LC THEN
                RETURN.TXN.ID = 1
            END
        CASE R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ "PS" AND ST.VALID AND ST.INSTALLED AND COMP.ST
            CALL F.READ(FN.ST,R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>,R.ST,FV.ST,ST.ERR)
            IF R.ST THEN
                RETURN.TXN.ID = 1
            END

        CASE R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ "LD" AND LD.VALID AND LD.INSTALLED AND COMP.LD
            CALL F.READ(FN.LD,R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>,R.LD,FV.LD,LD.ERR)
            IF R.LD THEN
                RETURN.TXN.ID = 1
            END

        CASE R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ "PD" AND PD.VALID AND PD.INSTALLED AND COMP.PD
            CALL F.READ(FN.PD,R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>,R.PD,FV.PD,PD.ERR)
            IF R.PD THEN
                RETURN.TXN.ID = 1
            END

        CASE R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ "MD" AND MD.VALID AND MD.INSTALLED AND COMP.MD
            CALL F.READ(FN.MD,R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>,R.MD,FV.MD,MD.ERR)
            IF R.MD THEN
                RETURN.TXN.ID = 1
            END

    END CASE

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= BUILD.RET.ARRAY>
BUILD.RET.ARRAY:
*** <desc>Build Return Array </desc>

    RET.ARR<1,-1> = EFF.DT
    RET.ARR<2,-1> = R.AA.ACT.HIST<AA.AH.ACTIVITY.REF,CNT.DT,CNT.ACT>
    RET.ARR<3,-1> = R.AA.ACT.HIST<AA.AH.ACTIVITY,CNT.DT,CNT.ACT>
    RET.ARR<4,-1> = R.AA.ACT.HIST<AA.AH.SYSTEM.DATE,CNT.DT,CNT.ACT>
    RET.ARR<5,-1> = R.AA.ACT.HIST<AA.AH.ACTIVITY.AMT,CNT.DT,CNT.ACT>
    RET.ARR<6,-1> = R.AA.ACT.HIST<AA.AH.ACT.STATUS,CNT.DT,CNT.ACT>
    RET.ARR<7,-1> = R.AA.ACT.HIST<AA.AH.INITIATION,CNT.DT,CNT.ACT>
    IF RETURN.TXN.ID THEN
        RET.ARR<8,-1> = R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>
    END ELSE
        RET.ARR<8,-1> = " "
    END

    RET.VAL<-1> = UPD.CNT

    UPD.CNT += 1

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= REV.REPLAY.CHK>
REV.REPLAY.CHK:
*** <desc>While Reverse and Replay check to find activities that should be dislpayed for authorisation. </desc>

    R.AAA = '' ; NEW.OR.MASTER.ACT = '' ; ALLOW.ACTIVITY.PROC.FLAG = ''
    CALL F.READ(FN.AAA, R.AA.ACT.HIST<AA.AH.ACTIVITY.REF,CNT.DT,CNT.ACT>, R.AAA, FV.AAA, READ.ERR)
    MASTER.ID = R.AAA<AA.ARR.ACT.MASTER.AAA>
    REV.MASTER.ID = R.AAA<AA.ARR.ACT.REV.MASTER.AAA>
    ACT.REF.ID =  R.AA.ACT.HIST<AA.AH.ACTIVITY.REF,CNT.DT,CNT.ACT>

    IF REV.MASTER.ID NE '' THEN         ;* If reversal has happened
        IF REV.MASTER.ID EQ ACT.REF.ID THEN
            ALLOW.ACTIVITY.PROC.FLAG = '1'
        END
    END ELSE        ;* Other activities that do not involve reverse/replay.
        IF MASTER.ID EQ ACT.REF.ID THEN
            ALLOW.ACTIVITY.PROC.FLAG = '1'
        END
    END

RETURN
END
