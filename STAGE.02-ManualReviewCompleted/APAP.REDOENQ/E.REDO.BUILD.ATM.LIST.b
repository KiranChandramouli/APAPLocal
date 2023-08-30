$PACKAGE APAP.REDOENQ
SUBROUTINE E.REDO.BUILD.ATM.LIST(ENQ.DATA)
*
* ====================================================================================
*
*     RETURNS ATM'S FOR CURRENT BRANCH
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.LIST.ACCTS.COMPANY
* Attached as     :
* Primary Purpose :
*
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : JOAQUIN COSTA C.
* Date            : 2012-07-23
*  DATE             WHO                   REFERENCE 
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - FM to @FM and F.READ to CACHE.READ
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY
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
* ======
PROCESS:
* ======
*
    ENQ.DATA<2,Y.POS> = "@ID"
    ENQ.DATA<3,Y.POS> = "EQ"
    ENQ.DATA<4,Y.POS> = WFINAL.LIST
*
RETURN
*
* =========================
SELECT.RECORDS.FROM.BRANCH:
* =========================
*
    WBRANCH.ID  = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
    WACCT.LIST  = R.CATEG.INT.ACCT
    WFINAL.LIST = ""
*
    LOOP
        REMOVE WACCOUNT.ID FROM WACCT.LIST SETTING ACCT.POS
    WHILE WACCOUNT.ID : ACCT.POS DO
        IF WACCOUNT.ID[13,4] EQ WBRANCH.ID THEN
            WFINAL.LIST <-1> = WACCOUNT.ID
        END
    REPEAT
*
    IF WFINAL.LIST THEN
        CHANGE @FM TO " " IN WFINAL.LIST
    END ELSE
        PROCESS.GOAHEAD = ""
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    FN.CATEG.INT.ACCT    = 'F.CATEG.INT.ACCT'
    F.CATEG.INT.ACCT     = ''
*
    LOOP.CNT        = 1
    MAX.LOOPS       = 3
    PROCESS.GOAHEAD = 1
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.CATEG.INT.ACCT,F.CATEG.INT.ACCT)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1 AND PROCESS.GOAHEAD
                LOCATE "CATEGORY" IN ENQ.DATA<2,1> SETTING Y.POS THEN
                    WCATEG.DATA = ENQ.DATA<4,Y.POS>
                END ELSE
                    ENQ.DATA<2,-1> = "CATEGORY"
                    ENQ.DATA<3,-1> = "EQ"
                    ENQ.DATA<4,-1> =  "10035"
                END

            CASE LOOP.CNT EQ 2 AND PROCESS.GOAHEAD
                LOCATE "CATEGORY" IN ENQ.DATA<2,1> SETTING Y.POS THEN
                    WCATEG.DATA = ENQ.DATA<4,Y.POS>
                END
                CALL CACHE.READ(FN.CATEG.INT.ACCT, WCATEG.DATA, R.CATEG.INT.ACCT, ERR.CATEG)  ;*R22 Auto Conversion  - F.READ to CACHE.READ
                IF ERR.CATEG THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                GOSUB SELECT.RECORDS.FROM.BRANCH

        END CASE

        LOOP.CNT +=1
    REPEAT

*
RETURN
*

END
