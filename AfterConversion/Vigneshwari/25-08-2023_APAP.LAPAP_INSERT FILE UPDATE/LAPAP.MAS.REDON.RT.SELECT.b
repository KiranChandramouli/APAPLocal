* @ValidationCode : MjotODYxMTU0NTI0OkNwMTI1MjoxNjkyOTY0NTUxODI1OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Aug 2023 17:25:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.MAS.REDON.RT.SELECT
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE		 AUTHOR				Modification                 DESCRIPTION
*25/08/2023	 VIGNESHWARI	   MANUAL R22 CODE CONVERSION	      NOCHANGE
*25/08/2023	 CONVERSION TOOL   AUTO R22 CODE CONVERSION	   T24.BP,BP,LAPAP.BP is removed in insertfile
*-----------------------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE   ;*AUTO R22 CODE CONVERSION-START-T24.BP is removed in insertfile
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.DATES  ;*AUTO R22 CODE CONVERSION - END
    $INCLUDE I_F.ST.LAPAP.CRC.ROUNDUP.DET ;*AUTO R22 CODE CONVERSION -START -BP is removed in insertfile
    $INCLUDE I_F.ST.LAPAP.CRC.ROUNDUP ;*AUTO R22 CODE CONVERSION-END
    $INSERT I_LAPAP.MAS.REDON.RT.COMMON ;*AUTO R22 CODE CONVERSION -LAPAP.BP is removed in insertfile

    GOSUB DO.GET.PENDING

    RETURN

DO.GET.PENDING:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.CRC.ROUNDUP.DET : " WITH CRC.ROUNDUP.ID EQ " : Y.BATCH.ID.L

    CALL OCOMO("RUNNING WITH SELECT LIST : " : SEL.CMD)

    GOSUB DO.UPDATE.TO.PROCESSING

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.REC)
    RETURN

DO.UPDATE.TO.PROCESSING:
    Y.CNT = DCOUNT(Y.BATCH.ARR,@FM)
    FOR A = 1 TO Y.CNT STEP 1
        T.BATCH.ID = Y.BATCH.ARR<A>
        CALL F.READ(FN.CRC.ROUNDUP,T.BATCH.ID,R.CRC,F.CRC.ROUNDUP,ERR.CRC)

        IF R.CRC THEN
            R.CRC<ST.LAP68.BATCH.STATUS> = 'PROCESSING'
            CALL F.WRITE(FN.CRC.ROUNDUP, T.BATCH.ID, R.CRC)
            CALL JOURNAL.UPDATE('')
            CALL OCOMO('ROUNDUP BATCH: ' : T.BATCH.ID : ', updated to status PROCESSING')
        END

    NEXT A

    RETURN

END

