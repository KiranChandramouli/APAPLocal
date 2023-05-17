* Description           : This Routine is used to check the  value given in  the field YEAR.MONTH is a valid Year(YYYY)/YYYYMM
*
* Developed By          : Aravindhan B
*
* Development Reference : N10
*
* Attached To           : VERSION>REDO.H.REPORTS.PARAM,REDO.INP.N10
*
* Attached As           : SUBROUTINE
*---------------------------------------------------------------------------------
* Input Parameter:
* --------------------------------------------------------------------------------
* Argument#1 : -NA-
* Argument#2 : -NA-
* Argument#3 : -NA-
*
*---------------------------------------------------------------------------------
* Output Parameter:
* --------------------------------------------------------------------------------
* Argument#4 : -NA-
* Argument#5 : -NA-
* Argument#6 : -NA-
*---------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*  *************************
*---------------------------------------------------------------------------------
*
*---------------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.YR.MON.RAIS.ERR
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.H.REPORTS.PARAM
    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
***** *** Initialise the local variables ***

    Y.YEAR.MONTH = '' ; Y.FREQ.REQ = '' ; Y.FREQ.REQ = '' ; Y.MAND.LEN = ''
    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
******** *** Get the ID and read the record of EB.LOOKUP to get the data values to check valid Year/Month***

    IF COMI THEN
        Y.YEAR.MONTH = COMI
        Y.FREQ.REQ = R.NEW(REDO.REP.PARAM.FREQUENCY.REQ)
        Y.EB.LOOKUP.ID = "REDO.REP.FREQ.REQ*":Y.FREQ.REQ
        GOSUB READ.EB.LOOKUP
        GOSUB CHK.DATA.VALS
    END
RETURN
*---------------------------------------------------------------------------------
CHK.DATA.VALS:
************* *** Check the Month and Year is valid or not ***
    BEGIN CASE
        CASE Y.DATA.1 AND Y.DATA.2
            IF Y.YEAR.MONTH LT Y.DATA.1 OR Y.YEAR.MONTH GT Y.DATA.2 THEN
                ETEXT= "EB-REDO.NOT.VALID.YEAR"
            END
        CASE Y.DATA.1 AND NOT(Y.DATA.2)
            CALL IN2YM(Y.DATA.1,'YM')
    END CASE
RETURN
*---------------------------------------------------------------------------------
READ.EB.LOOKUP:
***************
    R.EB.LOOKUP = '' ; EB.LOOKUP.ERR = ''
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
    IF R.EB.LOOKUP THEN
        Y.DATA.1 = R.EB.LOOKUP<EB.LU.DATA.VALUE,1>
        Y.DATA.2 = R.EB.LOOKUP<EB.LU.DATA.VALUE,2>
    END
RETURN
*---------------------------------------------------------------------------------
END       ;* End of the Program
