* @ValidationCode : MjotMTUwMDc2NDE4MjpDcDEyNTI6MTY4MDc2NDAxMjg1Mjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 12:23:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.REGN22.EXTRACT(REC.ID)
*----------------------------------------------------------------------------
* Company Name   : APAP
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.REGN22.EXTRACT
* Date           : 10-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the securities happened on daily basis
*----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
*
    $INSERT I_DR.REG.REGN22.EXTRACT.COMMON
*
    GOSUB PROCESS
*
RETURN
*----------------------------------------------------------------------------
PROCESS:
*------*
*
    CALL F.READ(FN.SEC.TRADE,REC.ID,R.SEC.TRADE,F.SEC.TRADE,SEC.TRADE.ERR)
    IF R.SEC.TRADE THEN
        RCL.MAP.FMT    = "MAP"
        RCL.ID         = "DR.REG.REGN22.EXT"
        RCL.BASE.APP   = FN.SEC.TRADE
        RCL.BASE.ID    = REC.ID
        RCL.BASE.R.REC = R.SEC.TRADE
        RETURN.MSG     = ""
        ERROR.MSG      = ""
        CALL RAD.CONDUIT.LINEAR.TRANSLATION(RCL.MAP.FMT, RCL.ID, RCL.BASE.APP, RCL.BASE.ID, RCL.BASE.R.REC, RETURN.MSG, ERROR.MSG)
        IF RETURN.MSG THEN
            CALL F.WRITE(FN.DR.REG.REGN22.WORKFILE, REC.ID, RETURN.MSG)
        END
    END
*
RETURN
*----------------------------------------------------------------------------
END
