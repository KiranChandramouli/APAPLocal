* @ValidationCode : MjoxODE4MjY5OTU1OlVURi04OjE3MDQxOTk3MzMwNjc6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jan 2024 18:18:53
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.CHARGES
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : CONVERSION ROUTINE
* Attached to     : REDO.E.DESEMBOLSO
* Attached as     : CONVERSION.ROUTINE
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : JoaquCosta C
* Date            : 2011-12-05
* 11-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 02-01-2024         Narmadha V            Manual R22 Conversion  - CALL OPF Added.
*=======================================================================


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
*
*    DEBUG
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*--------
PROCESS:
*--------
*
    WNUM.CHARGE = DCOUNT(R.RCA<REDO.FC.CHARG.DISC>,@VM)
    WSUM.CHARGE = SUM(R.RCA<REDO.FC.CHARG.AMOUNT>)
*
    WSUMF.CHARGE = FMT(WSUM.CHARGE,"R2,#19")
*
    IF WNUM.CHARGE NE 0 OR WSUM.CHARGE NE 0 THEN
        O.DATA = WNUM.CHARGE : " CARGOS POR " : WSUMF.CHARGE
    END ELSE
        O.DATA = ""
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT) ;*Manual R22 Conversion
*
    PROCESS.GOAHEAD = 1
    WRCA.ID         = O.DATA
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1;    MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,WRCA.ID,R.RCA,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)
* -----

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
