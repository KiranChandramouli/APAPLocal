* @ValidationCode : Mjo5NTU2NTUwMDI6Q3AxMjUyOjE2OTkzNjM0NDg2NTk6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Nov 2023 18:54:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
