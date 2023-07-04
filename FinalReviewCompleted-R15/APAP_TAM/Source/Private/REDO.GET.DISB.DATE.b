* @ValidationCode : MjotMTQ3NjMwNzU1NzpDcDEyNTI6MTY4Mzg5MjYyMzczMTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:03
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.DISB.DATE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY



    Y.AA.IDS = O.DATA

    FN.AA.HIS = 'F.AA.ACTIVITY.HISTORY'
    F.AA.HIS = ''
    CALL OPF(FN.AA.HIS,F.AA.HIS)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA = ''
    CALL OPF(FN.AAA,F.AAA)


    Y.AA.IDS = CHANGE(Y.AA.IDS,@SM,@VM)
    Y.CNT = DCOUNT(Y.AA.IDS,@VM)
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.ID = Y.AA.IDS<1,FLG>
        CALL F.READ(FN.AA.HIS,Y.ID,R.AA.HIS,F.AA.HIS,HIS.ERR)
        Y.ACT = R.AA.HIS<AA.AH.ACTIVITY>
        Y.ACT.ST = R.AA.HIS<AA.AH.ACT.STATUS>
        Y.ACT.AMT = R.AA.HIS<AA.AH.ACTIVITY.AMT>
        Y.ACT.REF = R.AA.HIS<AA.AH.ACTIVITY.REF>
        Y.EF.DT = R.AA.HIS<AA.AH.EFFECTIVE.DATE> ; Y.CNT.E = DCOUNT(Y.EF.DT,@VM) ; FLG.L = ''
        LOOP
        WHILE Y.CNT.E GT 0 DO
            FLG.L += 1
            LOCATE 'LENDING-DISBURSE-COMMITMENT' IN Y.ACT<1,FLG.L,1> SETTING POS THEN
                IF Y.ACT.ST<1,FLG.L,POS> EQ 'AUTH' THEN
                    Y.DISB.DATE<1,FLG,-1> = Y.EF.DT<1,FLG.L>
                    Y.DISB.AMT<1,FLG,-1> = Y.ACT.AMT<1,FLG.L,POS>
                END
            END
            Y.CNT.E -= 1
        REPEAT
        Y.CNT -= 1
    REPEAT

    IF Y.DISB.DATE OR Y.DISB.AMT THEN
        O.DATA = Y.DISB.DATE:'*':Y.DISB.AMT
    END ELSE
        O.DATA = ''
    END

RETURN

END
