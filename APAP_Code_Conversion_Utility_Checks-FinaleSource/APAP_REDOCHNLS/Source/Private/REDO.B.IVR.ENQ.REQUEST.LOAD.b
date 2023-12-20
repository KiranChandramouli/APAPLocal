* @ValidationCode : Mjo5NTU2NTUwMDI6Q3AxMjUyOjE2OTk1MDY0NzMzMjI6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
    SUBROUTINE REDO.B.IVR.ENQ.REQUEST.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE          AUTHOR                   Modification                            DESCRIPTION
*07-Nov-2023  Harishvikram C   Manual R22 conversion    Batch created for IVRInterfaceTWS Fix
*07/10/2023   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES            NOCHANGES
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Interface
    $USING EB.Service
    $INSERT I_REDO.B.IVR.ENQ.REQUEST.COMMON
    $INSERT I_F.REDO.IVR.ENQ.REQ.RESP

    FN.IVR ='F.REDO.IVR.ENQ.REQ.RESP'
    F.IVR = ''
    EB.DataAccess.Opf(FN.IVR, F.IVR)

    RETURN
END
