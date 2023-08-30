* @ValidationCode : Mjo3ODA3Njc4MjQ6Q3AxMjUyOjE2ODIwNjg1NjYzMjM6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 14:46:06
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           INCLUDE TO INSERT, ++ TO +=, -- TO -=, VM TO @VM
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.NOF.BUILD.AZ.INT.FWD(ENQ.DATA)
*
* Description: This routine is attached to the Enquiry 'REDO.AZ.INT.FWD.RATE.PROB'
* Dev by: V.P.Ashokkumar
*
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT ;*AUTO R22 CODE CONVERSION - END

    GOSUB INIT
    GOSUB INIT.PROC
RETURN

INIT:
****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    SEL.CMD = ''; SEL.LST =''; SEL.REC = ''
    ERR.SEL = ''; DEP.POSN = ''
RETURN

INIT.PROC:
**********
    SEL.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH TYPE.OF.SCHDLE EQ 'R' AND SCH.FIXED.RATE NE ''"
    CALL EB.READLIST(SEL.CMD,SEL.LST,'',SEL.REC,ERR.SEL)
    LOOP
        REMOVE DEPOS.ID FROM SEL.LST SETTING DEP.POSN
    WHILE DEPOS.ID:DEP.POSN

        ERR.AZ = ''; R.AZ.ACCOUNT = ''; YINT.CNT = 0; FLD1 = ''; FLD2 = ''; YCNT = 0
        CALL F.READ(FN.AZ.ACCOUNT,DEPOS.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ERR.AZ)
        FLD1 = R.AZ.ACCOUNT<AZ.CATEGORY>
        FLD2 = R.AZ.ACCOUNT<AZ.TYPE.OF.SCHDLE>
        YINT.CNT = DCOUNT(FLD2,@VM)
        LOOP
        UNTIL YINT.CNT EQ 0
            YCNT += 1 ;*AUTO R22 CODE CONVERSION
            FLD.2 = ''; FLD3 = ''
            FLD.2 = R.AZ.ACCOUNT<AZ.TYPE.OF.SCHDLE,YCNT>
            FLD3 = R.AZ.ACCOUNT<AZ.SCH.FIXED.RATE,YCNT>
            IF YCNT NE 1 THEN
                DEPOS.ID = ''; FLD1 = ''
            END
            ENQ.DATA<-1> = DEPOS.ID:'|':FLD.2:'|':FLD3:'|':FLD1

            YINT.CNT -= 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    REPEAT
RETURN

END
