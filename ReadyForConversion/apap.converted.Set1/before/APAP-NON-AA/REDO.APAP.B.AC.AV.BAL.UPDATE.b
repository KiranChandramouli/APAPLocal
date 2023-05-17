*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.B.AC.AV.BAL.UPDATE(ACCOUNT.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.AC.AV.BAL.UPDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.B.AC.AV.BAL.UPDATE is the main processsing routine, this routine is used to
*                    update the local reference field L.AC.AV.BAL which will be difference between the
*                    amount of WORKING.BALANCE and LOCKED.AMOUNT
*Linked With       : Batch BNK/REDO.B.AC.AV.BAL.UPDATE
*In  Parameter     : ACCOUNT.ID
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 24 Nov 2010       Shiva Prasad Y       ODR-2010-11-0196 CR012         Initial Creation
* 13 Apr 2011       H Ganesh              PACS00054323 - CR012         Changes made for locked amount calculation.
* 05 JUN 2011       Prabhu N              PACS00071064                 Line 73 to 75 added
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_REDO.APAP.B.AC.AV.BAL.UPDATE.COMMON ;*Tus Start
$INSERT I_F.EB.CONTRACT.BALANCES ;*Tus End
*
  GOSUB PROCESS

  RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*------*
*
  GOSUB PROCESS.PARA
*
  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
  GOSUB READ.ACCOUNT

  IF R.ACCOUNT EQ '' THEN
    RETURN
  END
 * Y.AMT = R.ACCOUNT<AC.WORKING.BALANCE> ;*Tus Start
  Y.AMT = R.ECB<ECB.WORKING.BALANCE>;*Tus End
  GOSUB GET.LOCKED.AMOUNT
  Y.AC.AV.BAL = 0
  Y.AC.AV.BAL = Y.AMT - Y.LOCK.AMT

  IF R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> EQ Y.AC.AV.BAL THEN
    RETURN
  END

  R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> = Y.AC.AV.BAL

  GOSUB WRITE.ACCOUNT

  RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.LOCKED.AMOUNT:
******************

  Y.LOCK.AMT = 0
  IF NOT(R.ACCOUNT<AC.FROM.DATE>) THEN
    Y.LOCK.AMT = 0
    RETURN
  END

  Y.DATE.COUNT = DCOUNT(R.ACCOUNT<AC.FROM.DATE>,VM)
  Y.DATE.START = 1

  LOOP
  WHILE Y.DATE.START LE Y.DATE.COUNT
    IF R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> LE TODAY THEN
      Y.LOCK.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
    END
*        IF TODAY GE R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> AND TODAY LT R.ACCOUNT<AC.FROM.DATE,Y.DATE.START+1> THEN
*            Y.LOCK.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
*            BREAK
*        END
    Y.DATE.START += 1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
  R.ACCOUNT  = ''
  ACCOUNT.ER = ''
  CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
  R.ECB='' ; ECB.ERR= '' ;*Tus Start
  CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ACCOUNT.ID,R.ECB,ECB.ERR) ;*Tus End
  RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.ACCOUNT:
**************
  CALL F.WRITE(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT)

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
