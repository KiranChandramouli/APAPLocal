*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.RISK.GROUP
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.V.VAL.RISK.GROUP
*---------------------------------------------------------------------------------

* DESCRIPTION       :If the loan is having any Co-Debtor and Guarantor , based on the
* Risk Group status of the customer a routine should go and check whether the Co-Debtor
* and Guarantor are falls in the Risk Group same as the Primary Customer . If they fall
* on the same Risk Group the process ends here.But if the Co-Debtor and Guarantor falls
* on the different Risk Group then  a routine should go and increase the value in the
* field Used Amount  of CREDIT LIMIT MAINTENANCE  table for the authorized LOAN / LIMIT
* value. And the value in the field Available amount  should be reduced for the authorized
* LOAN / LIMIT value. This process also should happen Online
*LINKED WITH       : NA
* ----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*06.07.2010      SUDHARSANAN S      ODR-2009-10-0578   INITIAL CREATION
*
* 15/03/2011      Ravikiran AV        PACS00034161      Get the customer from AAA record
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.AA.CUSTOMER
$INSERT I_F.AA.TERM.AMOUNT
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.CUSTOMER
$INSERT I_F.CREDIT.LIMIT.MAINTENANCE

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*-----*
INIT:
*-----*
*intilaise the variables

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMT= ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.CUSTOMER= 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.CREDIT.LIMIT.MAINTENANCE = 'F.CREDIT.LIMIT.MAINTENANCE'
  F.CREDIT.LIMIT.MAINTENANCE = ''
  CALL OPF(FN.CREDIT.LIMIT.MAINTENANCE,F.CREDIT.LIMIT.MAINTENANCE)


  ARR.ID=c_aalocArrId
  EFF.DATE=TODAY
  PROPERTY=''
  R.Condition=''
  R.TERM.AMT = ''
  ERR.MSG=''
  RETURN

*--------*
PROCESS:
*--------*

  PROP.CLASS='CUSTOMER'
  CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
  PRIM.CUST =  R.Condition<AA.CUS.PRIMARY.OWNER>
  Y.OWNER = R.Condition<AA.CUS.OWNER,1>
  IF PRIM.CUST EQ Y.OWNER THEN
    RETURN
  END ELSE

*PACS00034161
*    Y.OWNER = c_aalocArrangementRec<AA.ARR.ACT.CUSTOMER>
*PACS00034161

    CALL F.READ(FN.CUSTOMER,Y.OWNER,R.CUST,F.CUSTOMER,CUS.ERR)
    VAR.SECTOR = R.CUST<EB.CUS.SECTOR>
    CALL CACHE.READ(FN.CREDIT.LIMIT.MAINTENANCE,'SYSTEM',R.CRD.LIM.MAIN,CRD.ERR)
* PROPERTY.CLASS = 'TERM.AMOUNT'
* CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.TERM.AMT,ERR.MSG)
    COMMITTMENT.AMT = R.NEW(AA.AMT.AMOUNT)
    IF VAR.SECTOR EQ 1002 THEN
      GOSUB IND.AVAIL.AMT
    END ELSE
      GOSUB REL.AVAIL.AMT
    END
    CALL F.WRITE(FN.CREDIT.LIMIT.MAINTENANCE,'SYSTEM',R.CRD.LIM.MAIN)
  END
  RETURN
*-----------------------------------------------------------------
IND.AVAIL.AMT:
*--------------------------------------------------------------------
  LOCATE "EXECUTIVES.AND.EMP.INDIVIDUAL.LIMIT" IN R.CRD.LIM.MAIN<CRD.LIM.TYPE.OF.GROUP,1> SETTING GROUP.POS THEN
    AVAILABLE.AMT = R.CRD.LIM.MAIN<CRD.LIM.AVAILABLE.AMOUNT,GROUP.POS>
    USED.AMT = R.CRD.LIM.MAIN<CRD.LIM.USED.AMOUNT,GROUP.POS>
    R.CRD.LIM.MAIN<CRD.LIM.USED.AMOUNT,GROUP.POS> = USED.AMT + COMMITTMENT.AMT
    R.CRD.LIM.MAIN<CRD.LIM.AVAILABLE.AMOUNT,GROUP.POS> = AVAILABLE.AMT - COMMITTMENT.AMT
  END
  RETURN
*---------------------------------------------------------------------
REL.AVAIL.AMT:
*----------------------------------------------------------------------
  LOCATE "RELATED.GLOBAL.LIMIT" IN R.CRD.LIM.MAIN<CRD.LIM.TYPE.OF.GROUP,1> SETTING GROUP.POS THEN
    AVAILABLE.AMT = R.CRD.LIM.MAIN<CRD.LIM.AVAILABLE.AMOUNT,GROUP.POS>
    USED.AMT = R.CRD.LIM.MAIN<CRD.LIM.USED.AMOUNT,GROUP.POS>
    R.CRD.LIM.MAIN<CRD.LIM.USED.AMOUNT,GROUP.POS> = USED.AMT + COMMITTMENT.AMT
    R.CRD.LIM.MAIN<CRD.LIM.AVAILABLE.AMOUNT,GROUP.POS> = AVAILABLE.AMT - COMMITTMENT.AMT
  END
  RETURN
*---------------------------------------------------------------------------------------------------
END
