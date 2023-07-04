* @ValidationCode : Mjo5ODI4Njk1Mzg6Q3AxMjUyOjE2ODQ4MzYwMzY5NDY6SVRTUzotMTotMToxNzQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 174
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.DS.AZ.DISCOUNT.RATE(INT.RATE)
***************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RASHMITHA M
* PROGRAM NAME: REDO.APAP.DS.AZ.DISCOUNT.RATE
* ODR NO      : ODR-2009-10-0346
*-------------------------------------------------------------------------------------------------------------
* DESCRIPTION:This is a conversion routine used to display the details from local table REDO.AZ.DISCOUNT.RATE

* PARAMETERS:
* In Parameter        : NA
* Out Parameter       : INT.RATE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO             REFERENCE          DESCRIPTION
* 25.08.2010  RASHMITHA M        ODR-2009-10-0346   INITIAL CREATION
* 19/02/2014  Vignesh Kumaar R   PACS00261598       AZ DEPOSIT DEALSLIP ALIGNMENT ISSUE

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   ++ to += , VM to @VM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

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
    NO.OF.DATE.RANGES=DCOUNT(Y.DATE.RANGES,@VM)
    VAR1=1

* Fix for PACS00261598 [AZ DEPOSIT DEALSLIP ALIGNMENT ISSUE]

    LOOP
    WHILE VAR1 LE NO.OF.DATE.RANGES
        Y.DATE:=FMT(Y.DATE.RANGES<1,VAR1>,"L2#11")
        Y.RATE:=FMT(Y.INT.RATE<1,VAR1>,"L2#11")
        VAR1 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
*    INT.RATE=Y.DATE:VM:VM::VM:SPACE(8):Y.RATE
    INT.RATE=Y.DATE:@VM:@VM:Y.RATE

* End of Fix

RETURN
*----------------------------------------------------------------------
READ.REDO.AZ.DISCOUNT.RATE:
*----------------------------------------------------------------------
    CALL F.READ(FN.REDO.AZ.DISCOUNT.RATE,Y.CATEGORY,R.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE,Y.REDO.AZ.DISCOUNT.RATE.ERR)
RETURN

*----------------------------------------------------------------------
END
