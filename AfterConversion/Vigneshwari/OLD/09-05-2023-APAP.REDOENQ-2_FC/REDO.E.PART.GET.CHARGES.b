$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.PART.GET.CHARGES
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : CONVERSION ROUTINE
* Attached to     : REDO.E.PART.DESEMBOLSO
* Attached as     : CONVERSION.ROUTINE
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Sivakumar K
* Date            : 2013-03-15
*
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*=======================================================================


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.REDO.AA.PART.DISBURSE.FC

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

*--------
PROCESS:
*--------

    WNUM.CHARGE = DCOUNT(R.RCA<REDO.PDIS.CHARG.DISC>,@VM)
    WSUM.CHARGE = SUM(R.RCA<REDO.PDIS.CHARG.AMOUNT>)

    WSUMF.CHARGE = FMT(WSUM.CHARGE,"R2,#19")

    IF WNUM.CHARGE NE 0 OR WSUM.CHARGE NE 0 THEN
        O.DATA = WNUM.CHARGE : " CARGOS POR " : WSUMF.CHARGE
    END ELSE
        O.DATA = ""
    END

RETURN

*----------
INITIALISE:
*----------

    FN.REDO.AA.PART.DISBURSE.FC = "F.REDO.AA.PART.DISBURSE.FC"
    F.REDO.AA.PART.DISBURSE.FC = ""
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)

    PROCESS.GOAHEAD = 1
    WRCA.ID         = O.DATA

RETURN

*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------

    LOOP.CNT  = 1;    MAX.LOOPS = 1
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,WRCA.ID,R.RCA,F.REDO.AA.PART.DISBURSE.FC,ERR.MSJ)
        END CASE
        LOOP.CNT +=1
    REPEAT

RETURN

END
