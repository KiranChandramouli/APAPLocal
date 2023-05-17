*--------------------------------------------------------------------------------------------------------
* <Rating>-23</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.INT.PROPERTY(Y.AA.ID,Y.EFF.DATE,Y.INTEREST,Y.INT.FLAG)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INT.PROPERTY
*--------------------------------------------------------------------------------------------------------
*Description  : This is call routine used to calculate interest rate
*Linked With  : ENQUIRY>REDO.APAP.CANC.LOAN.DET
*In Parameter : Y.AA.ID,Y.EFF.DATE
*Out Parameter: Y.INTEREST,Y.INT.FLAG
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  01 OCT 2010     JEEVA T              ODR-2010-03-0171          Initial Creation
*--------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.INTEREST.ACCRUALS

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN

*----------------------------------------------------------------------------------------------------------
OPEN.PARA:
*----------------------------------------------------------------------------------------------------------

  FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
  F.AA.INTEREST.ACCRUALS=''

  CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

  RETURN
*----------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*----------------------------------------------------------------------------------------------------------
  ARR.INFO<1> =Y.AA.ID
  R.ARRANGEMENT=''
  CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST)

  CLASS.LIST = ''
  INT.PROPERTY = ''
  CALL AA.GET.PROPERTY.CLASS(PROP.LIST, CLASS.LIST)         ;* Find their Property classes

  CLASS.LIST = RAISE(CLASS.LIST)
  PROP.LIST = RAISE(PROP.LIST)
  CLASS.CTR = ''

  LOOP

    REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
    CLASS.CTR +=1

  WHILE Y.CLASS:CLASS.POS

    IF Y.CLASS EQ "INTEREST" THEN

      INT.PROPERTY<-1> = PROP.LIST<CLASS.CTR>

    END

  REPEAT

  CHANGE FM TO '*' IN INT.PROPERTY
  Y.COUNT.PROP = DCOUNT(INT.PROPERTY,'*')
  INIT = 1

  LOOP

  WHILE INIT LE Y.COUNT.PROP

    Y.FIRST.PROP = FIELD(INT.PROPERTY,'*',INIT)
    AA.INTEREST.ACCRUALS.ID = Y.AA.ID:'-':Y.FIRST.PROP      ;* form the accrual id using the property
    CALL F.READ(FN.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ID,R.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ER)
    Y.ACCRUALS.RATE = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1,1>

    IF Y.ACCRUALS.RATE NE '' THEN

      Y.INTEREST=Y.ACCRUALS.RATE
      Y.INT.FLAG ='1'

    END ELSE

      RETURN

    END

    INIT++

  REPEAT

  RETURN
*----------------------------------------------------------------------------------------------------------
END
