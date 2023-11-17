* @ValidationCode : Mjo5MTYxMzU0MzpDcDEyNTI6MTY5OTUwNjQ3MzM0NTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Nov 2023 10:37:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
    SUBROUTINE REDO.B.IVR.ENQ.REQUEST.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE          AUTHOR                   Modification                            DESCRIPTION
*07-Nov-2023  Harishvikram C   Manual R22 conversion    Batch created for IVRInterfaceTWS Fix
*07/10/2023   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES            NOCHANGES
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Interface
    $USING EB.Service
    $INSERT I_REDO.B.IVR.ENQ.REQUEST.COMMON
    $INSERT I_F.REDO.IVR.ENQ.REQ.RESP
    
    SEL.CMD = "SELECT ":FN.IVR: ' WITH @ID LIKE ...IVR.REQUEST'
    EB.DataAccess.Readlist(SEL.CMD, LIST.ID, '', Selected, SystemReturnCode)
    EB.Service.BatchBuildList('', LIST.ID)

    RETURN
END
