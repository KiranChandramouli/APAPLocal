* @ValidationCode : MjoxODk4OTk2OTk2OkNwMTI1MjoxNzA0OTg4MTcyMDI5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 21:19:32
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
*09-01-2024   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES          SQA-12248 � By Santiago
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Interface
    $USING EB.Service
    $INSERT I_REDO.B.IVR.ENQ.REQUEST.COMMON
    $INSERT I_F.REDO.IVR.ENQ.REQ.RESP
    
*    SEL.CMD = "SELECT ":FN.IVR: ' WITH @ID LIKE ...IVR.REQUEST'	;*Fix SQA-12248 � By Santiago-commented
    
    SEL.CMD = "SELECT ": FN.IVR : " WITH PROCESSED EQ '' "	;*Fix SQA-12248 � By Santiago-new line is added
    EB.DataAccess.Readlist(SEL.CMD, LIST.ID, '', Selected, SystemReturnCode)
    EB.Service.BatchBuildList('', LIST.ID)

RETURN
END
