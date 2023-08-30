* @ValidationCode : MjotMTcxMTI4ODQ0NzpDcDEyNTI6MTY4MjMxNjExOTg0MjpJVFNTOi0xOi0xOjE4MzI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:31:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1832
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.AUT.FIN.CHG.DEDUCT
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : MARIMUTHU S
*  ODR Number        : PACS00203617
*  Program   Name    : REDO.AUT.FIN.CHG.DEDUCT
*-----------------------------------------------------------------------------
* DESCRIPTION       :  This routine will be used to restrict the multiple times of charge reduction from loan.
*-----------------------------------------------------------------------------
* Modification History
*----------------------
* 09 JUL 2012       S.MARIMUTHU          PACS00203617
*
* 26 JUL 2017       Edwin Charles D      PACS00613657

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM,++ TO += 1
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.VERSION
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.FC.FORM.DISB
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.AA.DISBURSE.METHOD

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*----
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
    R.REDO.CREATE.ARRANGEMENT  = ""
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.REDO.AA.DISBURSE.METHOD = 'F.REDO.AA.DISBURSE.METHOD'
    F.REDO.AA.DISBURSE.METHOD = ''
    CALL OPF(FN.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD)

    FN.REDO.CK.CHARGE.PAID = 'F.REDO.CK.CHARGE.PAID'
    F.REDO.CK.CHARGE.PAID = ''
    CALL OPF(FN.REDO.CK.CHARGE.PAID,F.REDO.CK.CHARGE.PAID)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.FT.TT.TRANSACTION = 'F.REDO.FT.TT.TRANSACTION$NAU'
    F.REDO.FT.TT.TRANSACTION = ''
    CALL OPF(FN.REDO.FT.TT.TRANSACTION,F.REDO.FT.TT.TRANSACTION)

    FN.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT  = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT)

    FN.REDO.AA.PART.DISBURSE.FC = 'F.REDO.AA.PART.DISBURSE.FC'
    F.REDO.AA.PART.DISBURSE.FC  = ''
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)


RETURN

PROCESS:
*-------
    Y.TEMP.FT.ID = ''
    Y.VER.TYPE = R.VERSION(EB.VER.VERSION.TYPE)

    IF Y.VER.TYPE EQ 'PSB' THEN
        Y.TEMP.FT.ID   = R.NEW(FT.CREDIT.THEIR.REF)
        Y.TEMP.ID = System.getVariable("CURRENT.RPD.ID")
        IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN   ;*Tus Start
            Y.TEMP.ID = ''
        END         ;*Tus End
        GOSUB CHECK.OTHER.FT.PARTIAL.DISB
    END

    IF Y.VER.TYPE EQ 'DSB' THEN
        Y.TEMP.FT.ID   = R.NEW(FT.CREDIT.THEIR.REF)
        Y.TEMP.ID = R.NEW(FT.DEBIT.ACCT.NO)
        GOSUB CHECK.OTHER.FT.FULL.DISB
    END

    IF R.REDO.CK.CHARGE.PAID<1> NE 'PAID' AND Y.TEMP.ID AND Y.TEMP.FT.ID THEN
*CALL REDO.AUT.MANU.SETTLE.CHARGE
** R22 Manual conversion
        CALL APAP.REDOVER.REDO.AUT.MANU.SETTLE.CHARGE
        R.REDO.CK.CHARGE.PAID<1> = 'PAID'
        R.REDO.CK.CHARGE.PAID<2,-1> = Y.TEMP.FT.ID: " - PAID"
        CALL F.WRITE(FN.REDO.CK.CHARGE.PAID,Y.TEMP.ID,R.REDO.CK.CHARGE.PAID)
        GOSUB POST.OFS
    END

RETURN
*-----------------------------------------------------
POST.OFS:
*-----------------------------------------------------

    IF R.NEW(FT.DEBIT.VALUE.DATE) GE TODAY THEN   ;* We need to post dummy update OFS for interest issue - PACS00319715
        RETURN
    END
    Y.LOAN.ACC =  R.NEW(FT.DEBIT.ACCT.NO)
    IN.ARR.ID  = ''
    OUT.ID     = ''
*CALL REDO.CONVERT.ACCOUNT(Y.LOAN.ACC,IN.ARR.ID,OUT.ID,ERR.TEXT)
** R22 Manual conversion
    CALL APAP.TAM.REDO.CONVERT.ACCOUNT(Y.LOAN.ACC,IN.ARR.ID,OUT.ID,ERR.TEXT)
    IF OUT.ID ELSE
        RETURN
    END
    R.AAA = ''
    R.AAA<AA.ARR.ACT.ARRANGEMENT>    = OUT.ID
    R.AAA<AA.ARR.ACT.ACTIVITY>       = 'REDO.INITIAL.UPDATE'
    R.AAA<AA.ARR.ACT.EFFECTIVE.DATE> = R.NEW(FT.DEBIT.VALUE.DATE)

    APP.NAME       = 'AA.ARRANGEMENT.ACTIVITY'
    OFSFUNCT       = 'I'
    PROCESS        = 'PROCESS'
    OFSVERSION     = 'AA.ARRANGEMENT.ACTIVITY,APAP'
    GTSMODE        = ''
    TRANSACTION.ID = ''
    OFSRECORD      = ''
    OFS.MSG.ID     = ''
    OFS.ERR        = ''
    NO.OF.AUTH     = 0

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AAA,OFSRECORD)
    OFS.MSG.ID = ''
    OFS.SRC    = 'REDO.AA.POOL'
    OPTIONS    = ''
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN
*-------------------------------------------
CHECK.OTHER.FT.PARTIAL.DISB:
*-------------------------------------------
* Here we will check whether all the FTs in the chain has been authorised. Because we need to post DISB OFS at the last FT of the chain.
* Because we had a problem dated xref corruption when we post OFS during authorization of 1st FT of chain because when Fast path authorization
* and OFS processing is simultaneous then dated xref gets corrupted(No locking mechanism available for dated xref in core whereas in higher release
* No activities are allowed on activity is in INAU).

    CALL F.READ(FN.REDO.CK.CHARGE.PAID,Y.TEMP.ID,R.REDO.CK.CHARGE.PAID,F.REDO.CK.CHARGE.PAID,CHG.ERR)
    CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,Y.TEMP.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,PFC.ERR)
    IF R.REDO.AA.PART.DISBURSE.FC ELSE
        R.REDO.CK.CHARGE.PAID<2,-1> = Y.TEMP.FT.ID:  ' - RCA RECORD MISSING'
        CALL F.WRITE(FN.REDO.CK.CHARGE.PAID,Y.TEMP.ID,R.REDO.CK.CHARGE.PAID)
        RETURN
    END

    Y.FT.IDS = R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.DIS.CODTXN>
    Y.FT.CNT = DCOUNT(Y.FT.IDS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.FT.CNT
        Y.FT.ID = Y.FT.IDS<1,Y.VAR1>
        IF Y.FT.ID EQ Y.TEMP.FT.ID THEN
            Y.VAR1 += 1                          ;** R22 Auto conversion - ++ TO += 1
            CONTINUE
        END
*        R.FUNDS.TRANSFER$NAU = ''
*        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER$NAU,F.FUNDS.TRANSFER,FT.ERR)
*        IF R.FUNDS.TRANSFER$NAU THEN
        R.REDO.FT.TT.TRANSACTION$NAU = ''
        CALL F.READ(FN.REDO.FT.TT.TRANSACTION,Y.FT.ID,R.REDO.FT.TT.TRANSACTION$NAU,F.REDO.FT.TT.TRANSACTION,FT.ERR)
        IF R.REDO.FT.TT.TRANSACTION$NAU THEN
            R.REDO.CK.CHARGE.PAID<2,-1> = Y.TEMP.FT.ID:  ' - INAU RECORD EXIST (':Y.FT.ID:')'
            CALL F.WRITE(FN.REDO.CK.CHARGE.PAID,Y.TEMP.ID,R.REDO.CK.CHARGE.PAID)
            GOSUB END1
        END

        Y.VAR1 += 1               ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
*-------------------------------------------
CHECK.OTHER.FT.FULL.DISB:
*-------------------------------------------
* Here we will check whether all the FTs in the chain has been authorised. Because we need to post DISB OFS at the last FT of the chain.
* Because we had a problem dated xref corruption when we post OFS during authorization of 1st FT of chain because when Fast path authorization
* and OFS processing is simultaneous then dated xref gets corrupted(No locking mechanism available for dated xref in core whereas in higher release
* No activities are allowed on activity is in INAU).

    CALL F.READ(FN.REDO.CK.CHARGE.PAID,Y.TEMP.ID,R.REDO.CK.CHARGE.PAID,F.REDO.CK.CHARGE.PAID,CHG.ERR)
    Y.DR.ACCOUNT = R.NEW(FT.DEBIT.ACCT.NO)
*CALL REDO.CONVERT.ACCOUNT(Y.DR.ACCOUNT,'',Y.AA.ID,ERR.TEXT)
** R22 Manual conversion
    CALL APAP.TAM.REDO.CONVERT.ACCOUNT(Y.DR.ACCOUNT,'',Y.AA.ID,ERR.TEXT)
    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT,Y.AA.ID,R.CNCT.ARR,F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT,CNCT.ERR)
    Y.FC.ID = FIELD(R.CNCT.ARR<1>,'*',2)
    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,Y.FC.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,RCA.ERR)
    IF R.REDO.CREATE.ARRANGEMENT ELSE
        R.REDO.CK.CHARGE.PAID<2,-1> = Y.TEMP.FT.ID:  '- RCA RECORD MISSING'
        CALL F.WRITE(FN.REDO.CK.CHARGE.PAID,Y.TEMP.ID,R.REDO.CK.CHARGE.PAID)
        RETURN
    END
    Y.FT.IDS = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.CODTXN>
    Y.FT.CNT = DCOUNT(Y.FT.IDS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.FT.CNT

        Y.FT.ID = Y.FT.IDS<1,Y.VAR1>
        IF Y.FT.ID EQ Y.TEMP.FT.ID THEN
            Y.VAR1 += 1                      ;** R22 Auto conversion - ++ TO += 1
            CONTINUE
        END
*        R.FUNDS.TRANSFER$NAU = ''
*        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER$NAU,F.FUNDS.TRANSFER,FT.ERR)
*        IF R.FUNDS.TRANSFER$NAU THEN
        R.REDO.FT.TT.TRANSACTION$NAU = ''
        CALL F.READ(FN.REDO.FT.TT.TRANSACTION,Y.FT.ID,R.REDO.FT.TT.TRANSACTION$NAU,F.REDO.FT.TT.TRANSACTION,FT.ERR)
        IF R.REDO.FT.TT.TRANSACTION$NAU THEN
            R.REDO.CK.CHARGE.PAID<2,-1> = Y.TEMP.FT.ID:  ' - INAU RECORD EXIST (':Y.FT.ID:')'
            CALL F.WRITE(FN.REDO.CK.CHARGE.PAID,Y.TEMP.ID,R.REDO.CK.CHARGE.PAID)
            GOSUB END1
        END
        Y.VAR1 += 1                 ;** R22 Auto conversion - ++ TO += 1
    REPEAT
RETURN
*----------------------------------------------
END1:
*----------------------------------------------
* Program exit here.
END
