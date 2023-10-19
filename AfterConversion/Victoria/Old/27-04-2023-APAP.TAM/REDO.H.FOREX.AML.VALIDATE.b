$PACKAGE APAP.TAM
SUBROUTINE REDO.H.FOREX.AML.VALIDATE

*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.H.FOREX.AML table fields
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Chandra Prakash T
* PROGRAM NAME : REDO.H.FOREX.AML.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference         Description
* 09-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
** 11-04-2023 R22 Auto Conversion no changes
** 11-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.FOREX.AML

    GOSUB PROCESS

RETURN

PROCESS:

    BEGIN CASE
        CASE R.NEW(FX.AML.AML.CCY) NE LCCY
            AML.FCY = R.NEW(FX.AML.AML.CCY)
            AML.FCY.AMT = R.NEW(FX.AML.AMT.LIMIT.FCY)
            EXCHG.RATE = ''
            CCY.MARKET = 1
            LCCY.AMT = ''
            DIF.AMT = ''
            DIF.RATE = ''
            CALL MIDDLE.RATE.CONV.CHECK(AML.FCY.AMT,AML.FCY,EXCHG.RATE,CCY.MARKET,LCCY.AMT,DIF.AMT,DIF.RATE)
            R.NEW(FX.AML.AMT.LIMIT.LCY) = LCCY.AMT
        CASE OTHERWISE
            R.NEW(FX.AML.AMT.LIMIT.LCY) = R.NEW(FX.AML.AMT.LIMIT.FCY)
    END CASE

RETURN

END
