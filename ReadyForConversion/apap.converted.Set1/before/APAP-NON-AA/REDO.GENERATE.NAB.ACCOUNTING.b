*-----------------------------------------------------------------------------
* <Rating>-66</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GENERATE.NAB.ACCOUNTING(ARR.ID)

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will process the selected Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with STATUS is STARTED.
* This will raise a Consolidated Accounting Entry for NAB Contracts
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
*
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.REDO.AA.INT.CLASSIFICATION
$INSERT I_F.REDO.NAB.ACCOUNTING
$INSERT I_F.REDO.AA.NAB.HISTORY
$INSERT I_REDO.GENERATE.NAB.ACCOUNTING.COMMON

*------------------------------------------------------------------------------------------------------------------
* Main Logic of the routine
*
MAIN.LOGIC:

  GOSUB READ.NAB.HISTORY.REC

  GOSUB PROCESS

  RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Arrangement ids for Multi-Threaded Processing
*
PROCESS:

  GOSUB READ.NAB.PARAM

  RETURN
*------------------------------------------------------------------------------------------------------------------
*
*
READ.NAB.HISTORY.REC:

  CALL F.READ(FN.REDO.AA.NAB.HISTORY, ARR.ID, R.NAB.HIST.REC, F.REDO.AA.NAB.HISTORY, NAB.RET.ERR)

  GOSUB CHECK.FATAL.ERROR

  RETURN
*------------------------------------------------------------------------------------------------------------------
*
*
CHECK.FATAL.ERROR:

  MSG.INFO = ''

  IF (NAB.RET.ERR) THEN

    MSG.INFO<1> = 'REDO.GENERATE.NAB.ACCOUNTING'
    MSG.INFO<2> = ''
    MSG.INFO<3> = 'REDO.GENERATE.NAB.ACCOUNTING'
    MSG.INFO<4> = 'Cannot find record in REDO.GENERATE.NAB.ACCOUNTING'
    MSG.INFO<5> = 'YES'

    CALL FATAL.ERROR(MSG.INFO)

  END

  RETURN
*-----------------------------------------------------------------------------------------------------------------
*
*
READ.NAB.PARAM:

  CALL F.READ(FN.AA.ARRANGEMENT, ARR.ID, R.ARRANGEMENT, F.AA.ARRANGEMENT, RET.ERR)        ;*Read the Arrangement record for the Product

  IF NOT(RET.ERR) THEN        ;* If Arrangement found then update NAB Accounting Record

    AA.PRODUCT = R.ARRANGEMENT<AA.ARR.PRODUCT,1>
    COMP = R.ARRANGEMENT<AA.ARR.CO.CODE>

    IF (COMP EQ ID.COMPANY) THEN
      GOSUB UPDATE.NAB.ACC.REC          ;* Update the NAB Accounting rec for the CURRENCY-SECTOR
    END
  END

  RETURN
*-------------------------------------------------------------------------------------------------------------------
*
*
UPDATE.NAB.ACC.REC:

  NAB.ACC.ID = R.NAB.HIST.REC<REDO.NAB.HIST.CURRENCY>:'-':R.NAB.HIST.REC<REDO.NAB.HIST.SECTOR>:'-':R.NAB.HIST.REC<REDO.NAB.HIST.L.LOAN.STATUS>:'-':AA.PRODUCT:'-':ID.COMPANY


  NAB.DATE = R.NAB.HIST.REC<REDO.NAB.HIST.NAB.CHANGE.DATE>
  NAB.AMT = ''

  BILL.IDS = R.NAB.HIST.REC<REDO.NAB.HIST.BILL.ID>

  CHANGE VM TO FM IN BILL.IDS
  CHANGE SM TO FM IN BILL.IDS

  BILL.COUNT = DCOUNT(BILL.IDS,FM)

  FOR BILL = 1 TO BILL.COUNT

    BILL.NO = BILL.IDS<BILL>

    BILL.DATE = FIELD(BILL.NO,'-',2)
    BILL.ID = FIELD(BILL.NO,'-',1)

    IF BILL.DATE EQ NAB.DATE THEN

      NAB.AMT = NAB.AMT + R.NAB.HIST.REC<REDO.NAB.HIST.INT.BALANCE,BILL>

    END

  NEXT BILL

  CALL F.READU(FN.REDO.NAB.ACCOUNTING, NAB.ACC.ID, NAB.ACC.REC, F.REDO.NAB.ACCOUNTING,RET.ERR,'')

  IF (RET.ERR) THEN ;* Update the NAB.ACC.ID as new record

    NAB.ACC.REC<REDO.NAB.ACC.NAB.AMT> = NAB.AMT

  END ELSE

    NAB.ACC.AMT =  NAB.ACC.REC<REDO.NAB.ACC.NAB.AMT>
    NAB.ACC.REC<REDO.NAB.ACC.NAB.AMT> = NAB.ACC.AMT + NAB.AMT

  END

  NAB.ACC.REC<REDO.NAB.ACC.PRODUCT> = AA.PRODUCT
  NAB.ACC.REC<REDO.NAB.ACC.LOAN.STATUS> = R.NAB.HIST.REC<REDO.NAB.HIST.L.LOAN.STATUS>

  CALL F.WRITE(FN.REDO.NAB.ACCOUNTING, NAB.ACC.ID, NAB.ACC.REC)

  CALL F.RELEASE(FN.REDO.NAB.ACCOUNTING, NAB.ACC.ID, F.REDO.NAB.ACCOUNTING)

  RETURN
*-------------------------------------------------------------------------------------------------------------------
*
*
END
