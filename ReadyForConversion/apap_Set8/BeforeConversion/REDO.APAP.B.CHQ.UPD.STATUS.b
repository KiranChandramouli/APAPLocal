*-----------------------------------------------------------------------------
* <Rating>-5</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.B.CHQ.UPD.STATUS(ARR.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.CHQ.UPD.STATUS
*--------------------------------------------------------------------------------------------------------
*Description       : This is an MULTI-THREAD main PROCESS routine, This routine will check if the value
*                    in Cheque returned date is one year back from today.s date, then change the status DROPPED
*Linked With       : Batch REDO.APAP.B.CHQ.UPD.STATUS
*In  Parameter     : ARR.ID - Id of local file REDO.APAP.LOAN.CHEQUE.DETAILS
*Out Parameter     : N/A
*Files  Used       : REDO.APAP.LOAN.CHEQUE.DETAILS       As          I-o     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                  Reference                Description
*   ------            -----               -------------             -------------
* 10 Jun 2010     Shiva Prasad Y      ODR-2009-10-1678 B.10        Initial Creation
* 09-Dec-2010   Krishna Murthy T.S   TAM-ODR-2009-10-1678(B.10)    Modification to update the CHEQUE.STATUS
*                                                                  to DROPPED in REDO.LOAN.CHQ.RETURN table
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.APAP.B.CHQ.UPD.STATUS.COMMON
$INSERT I_F.REDO.APAP.LOAN.CHEQUE.DETAILS
$INSERT I_F.REDO.LOAN.CHQ.RETURN
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
*    GOSUB PROCESS.PARA
  GOSUB UPD.CHQ.STATUS

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  REDO.APAP.LOAN.CHEQUE.DETAILS.ID = ARR.ID
  GOSUB READ.REDO.APAP.LOAN.CHEQUE.DETAILS

  IF NOT(R.REDO.APAP.LOAN.CHEQUE.DETAILS) THEN
    RETURN
  END

  Y.REC.COUNT = DCOUNT(R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.TRANS.REF>,VM)
  Y.COUNT     = 1

  LOOP
  WHILE Y.COUNT LE Y.REC.COUNT
    IF R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.CHQ.STATUS,Y.COUNT,1> EQ 'DROPPED' THEN
      Y.COUNT +=1
      CONTINUE
    END

    IF R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.CHQ.RET.DATE,Y.COUNT,1> LT Y.BACK.DATE THEN
      R.REDO.APAP.LOAN.CHEQUE.DETAILS<CHQ.DET.CHQ.STATUS,Y.COUNT,1> = 'DROPPED'
    END
    Y.COUNT += 1
  REPEAT

  GOSUB WRITE.REDO.APAP.LOAN.CHEQUE.DETAILS

  RETURN
*--------------------------------------------------------------------------------------------------------
***********************************
READ.REDO.APAP.LOAN.CHEQUE.DETAILS:
***********************************
* In this para of the code, file REDO.APAP.LOAN.CHEQUE.DETAILS is read
  R.REDO.APAP.LOAN.CHEQUE.DETAILS  = ''
  REDO.APAP.LOAN.CHEQUE.DETAILS.ER = ''
  CALL F.READ(FN.REDO.APAP.LOAN.CHEQUE.DETAILS,REDO.APAP.LOAN.CHEQUE.DETAILS.ID,R.REDO.APAP.LOAN.CHEQUE.DETAILS,F.REDO.APAP.LOAN.CHEQUE.DETAILS,REDO.APAP.LOAN.CHEQUE.DETAILS.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
************************************
WRITE.REDO.APAP.LOAN.CHEQUE.DETAILS:
************************************
* In this para of the code, values are written on to local file REDO.APAP.LOAN.CHEQUE.DETAILS
  CALL F.WRITE(FN.REDO.APAP.LOAN.CHEQUE.DETAILS,REDO.APAP.LOAN.CHEQUE.DETAILS.ID,R.REDO.APAP.LOAN.CHEQUE.DETAILS)

  RETURN
*--------------------------------------------------------------------------------------------------------
*ODR2009101678-START.1

***************
UPD.CHQ.STATUS:
***************
  R.REDO.LOAN.CHQ.RETURN = ''
  Y.LCR.ERR = ''
  CALL F.READ(FN.REDO.LOAN.CHQ.RETURN,ARR.ID,R.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN,Y.LCR.ERR)
  IF R.REDO.LOAN.CHQ.RETURN THEN
    Y.CHQ.RET.DT.LIST = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.DT>
    Y.CHQ.RETAIN = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RETAIN>
    Y.CHQ.CNT = DCOUNT(Y.CHQ.RET.DT.LIST,VM)
    SYS.DATE = TODAY
    LOOP
      Y.CNT = 1
      REMOVE Y.CHQ.RET.DT FROM Y.CHQ.RET.DT.LIST SETTING Y.POS
    WHILE Y.CHQ.RET.DT:Y.POS
      IF Y.CHQ.RET.DT AND Y.CHQ.RET.DT LT SYS.DATE THEN
        Y.REGION = ''
        Y.DIFF = 'C'
        CALL CDD(Y.REGION,Y.CHQ.RET.DT,SYS.DATE,Y.DIFF)
        IF Y.DIFF GT Y.CHQ.RETAIN THEN
          R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.STATUS,Y.CNT> = 'DROPPED'
        END
      END
      Y.CNT += 1
    REPEAT
    CALL F.WRITE(FN.REDO.LOAN.CHQ.RETURN,ARR.ID,R.REDO.LOAN.CHQ.RETURN)
  END
  RETURN

*ODR2009101678-END.1
END
