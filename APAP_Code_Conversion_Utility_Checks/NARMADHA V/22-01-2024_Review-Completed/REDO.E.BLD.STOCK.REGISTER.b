* @ValidationCode : MjoxMzgzMDA5ODI2OlVURi04OjE3MDU5MDQxOTY5NDM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 11:46:36
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
* 22-12-2023      Narmadha V        Manual R22 Conversion      Changed ID and FN variable instead of Hardcoding
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
    Y.ID = "SYSTEM" ;*Manual R22 Conversion
*  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)
*CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,Y.ID,R.REDO.CARD.SERIES.PARAM,PARAM.ERR) ;*Manual R22 Conversion - Changed ID and FN variable instead of Hardcoding
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
