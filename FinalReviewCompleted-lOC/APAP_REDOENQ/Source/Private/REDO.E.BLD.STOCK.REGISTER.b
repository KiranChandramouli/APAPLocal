* @ValidationCode : MjotNDczMTE0OTAyOkNwMTI1MjoxNjgyMDczMzgyNDEyOklUU1M6LTE6LTE6OTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 90
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.STOCK.REGISTER(ENQ.DATA)
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* returns the list of IDs that is created to fetch stock register ID

*------------------------------------------------------------------------------------------------------
*APPLICATION
* build routine to be attached in the enquiry REDO.CARD.STOCK.REGISTER
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.E.BLD.STOCK.REGISTER
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO               REFERENCE         DESCRIPTION
*08.03.2011      Swaminathan     ODR-2010-03-0400   INITIAL CREATION
*
* 13-APR-2023     Conversion tool    R22 Auto conversion       F.READ to CACHE.READ
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.SERIES.PARAM


    GOSUB PROCESS
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------
    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
*  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)
    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    Y.RECEIVE.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
    Y.EMBOSS.DEPT.CODE =  R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.EMBOSS.DEPT.CODE>

    Y.LCO.VAL = ENQ.DATA<4,1>

    FN.COMPANY = 'F.COMPANY'
    F.COMAPNY = ''
    CALL OPF(FN.COMPANY,F.COMAPNY)
    CALL CACHE.READ(FN.COMPANY, Y.LCO.VAL, R.COMP, Y.ERR.COM) ;*R22 Auto conversion
    IF R.COMP EQ '' THEN
        ENQ.ERROR = 'EB-INVALID.COMP.ID'
        RETURN
    END

    IF Y.LCO.VAL EQ R.COMPANY(EB.COM.FINANCIAL.COM) THEN
        ENQ.DATA<2,1> = "@ID"
        ENQ.DATA<3,1> = "EQ"
        ENQ.DATA<4,1> = 'CARD.':Y.LCO.VAL:'-':Y.EMBOSS.DEPT.CODE
    END ELSE
        ENQ.DATA<2,1> = "@ID"
        ENQ.DATA<3,1> = "EQ"
        ENQ.DATA<4,1> = 'CARD.':Y.LCO.VAL:'-':Y.RECEIVE.DEPT.CODE
    END

RETURN
*------------------------------------------------------------
END
