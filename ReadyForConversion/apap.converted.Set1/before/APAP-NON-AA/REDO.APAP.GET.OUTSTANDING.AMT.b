*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.GET.OUTSTANDING.AMT(Y.DATE,ARRANGEMENT.ID,Y.AMT)
*********************************************************************************************************
*Company   Name     : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.GET.OUTSTANDING.AMT
*--------------------------------------------------------------------------------------------------------
*Description       :REDO.APAP.GET.OUTSTANDING.AMT is a subroutine used to calculate the outstanding amount
*                   of an arrangement on a particular date
*Used in           :Routines REDO.APAP.AUT.CPH.OPEN, REDO.APAP.AUT.CPH.MODIFY, REDO.APAP.INP.CAP.COVER,
*                   REDO.APAP.AUT.UPD.MORTGAGE.DET and REDO.APAP.NOFILE.MG.ACCT.NO
*In  Parameter     : Y.DATE and ARRANGEMENT.ID
*Out Parameter     : Y.OUT.AMT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  26/07/2010      Rashmitha M        ODR-2009-10-0346         Initial Creation
*********************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.TERM.AMOUNT

  GOSUB PROCESS.PARA
  RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************
  IF Y.DATE EQ TODAY THEN
    GOSUB CHECK.AA.LOAN.REPORT
  END ELSE
    GOSUB CHECK.AA.DETAILS.SCHEDULE
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.AA.LOAN.REPORT:
*--------------------------------------------------------------------------------------------------------

  O.DATA= ARRANGEMENT.ID
  CALL E.MB.AA.REPORT.HEADER
  Y.PRINCIPAL = FIELD(O.DATA,'*',8,1)

  Y.AMT = Y.PRINCIPAL
  RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.AA.DETAILS.SCHEDULE:
*--------------------------------------------------------------------------------------------------------

  ENQ.SELECTION<1,1> = 'E.AA.SCHEDULE.PROJECTOR'
  ENQ.SELECTION<2,1> = 'ARRANGEMENT.ID'
  ENQ.SELECTION<3,1> = 'EQ'
  ENQ.SELECTION<4,1> = ARRANGEMENT.ID


  CALL E.AA.SCHEDULE.PROJECTOR(Y.ENQ.OUT)
  IF Y.DATE LT FIELD(FIELD(Y.ENQ.OUT,FM,1),'^',1,1) THEN
    GOSUB CHECK.AA.TERM.AMOUNT
    RETURN
  END

  Y.VAL.COUNT=DCOUNT(Y.ENQ.OUT,FM)
  VAR1=1
  LOOP
  WHILE VAR1 LE Y.VAL.COUNT
    Y.REC=Y.ENQ.OUT<VAR1>
    IF Y.DATE LT FIELD(Y.REC,'^',1,1) THEN
*PACS00101744-S
*   Y.REC=Y.ENQ.OUT<VAR1-1>
*PACS00101744-E
      Y.AMT=FIELD(Y.REC,'^',7,1)
      EXIT
    END
    IF Y.DATE EQ FIELD(Y.REC,'^',1,1) THEN
      Y.AMT=FIELD(Y.REC,'^',7,1)
    END
    VAR1++
  REPEAT
  Y.AMT=ABS(Y.AMT)
  RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.AA.TERM.AMOUNT:
*--------------------------------------------------------------------------------------------------------

  EFF.DATE = ''
  PROP.CLASS='TERM.AMOUNT'
  PROPERTY = ''
  R.CONDITION = ''
  ERR.MSG = ''
  CALL REDO.CRR.GET.CONDITIONS(ARRANGEMENT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
  Y.AMT=R.CONDITION<AA.AMT.AMOUNT>

  RETURN
*--------------------------------------------------------------------------------------------------------
END
