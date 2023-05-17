*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DS.CF.DISCOUNT.RATE(INT.RATE)
***************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RASHMITHA M
* PROGRAM NAME: REDO.APAP.DS.AZ.DISCOUNT.RATE
* ODR NO      : ODR-2009-10-0346
*-------------------------------------------------------------------------------------------------------------
* DESCRIPTION:This is a conversion routine used to display the details from local table REDO.AZ.DISCOUNT.RATE
* This routine is used ofor CF related receipt.the alignment is made as per the layout..
* PARAMETERS:
* In Parameter        : NA
* Out Parameter       : INT.RATE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO            REFERENCE         DESCRIPTION
* 25.08.2010  RASHMITHA M    ODR-2009-10-0346   INITIAL CREATION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.REDO.AZ.DISCOUNT.RATE

  GOSUB OPENFILES
  GOSUB PROCESSNEW
  RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  FN.REDO.AZ.DISCOUNT.RATE='F.REDO.AZ.DISCOUNT.RATE'
  F.REDO.AZ.DISCOUNT.RATE=''
  CALL OPF(FN.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE)
  RETURN
*----------------------------------------------------------------------
PROCESSNEW:
*----------------------------------------------------------------------

  Y.CATEGORY = R.NEW(AZ.CATEGORY)
  GOSUB READ.REDO.AZ.DISCOUNT.RATE
  Y.DATE.RANGES=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.DATE.RANGE>
  Y.INT.RATE=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT>
  NO.OF.DATE.RANGES=DCOUNT(Y.DATE.RANGES,VM)
  VAR1=1
  LOOP
  WHILE VAR1 LE NO.OF.DATE.RANGES
    Y.DATE:=FMT(Y.DATE.RANGES<1,VAR1>,"L2#18")
    Y.RATE:=FMT(Y.INT.RATE<1,VAR1>,"L2#18")
    VAR1++
  REPEAT
  INT.RATE=Y.DATE:VM:VM:"   ":Y.RATE

  RETURN
*----------------------------------------------------------------------
READ.REDO.AZ.DISCOUNT.RATE:
*----------------------------------------------------------------------
  CALL F.READ(FN.REDO.AZ.DISCOUNT.RATE,Y.CATEGORY,R.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE,Y.REDO.AZ.DISCOUNT.RATE.ERR)
  RETURN

*----------------------------------------------------------------------
END
