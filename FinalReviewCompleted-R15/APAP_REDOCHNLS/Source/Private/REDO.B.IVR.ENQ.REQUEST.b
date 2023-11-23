* @ValidationCode : MjotNzg2MDEzODMxOkNwMTI1MjoxNjk5NTA2NDczMzY4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
    SUBROUTINE REDO.B.IVR.ENQ.REQUEST(Y.ID)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*DATE          AUTHOR                   Modification 
* 07-Nov-2023  Harishvikram C   Manual R22 conversion    Batch created for IVRInterfaceTWS Fix
* 07/10/2023   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES            NOCHANGES
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Interface
    $INSERT I_REDO.B.IVR.ENQ.REQUEST.COMMON
    $INSERT I_F.REDO.IVR.ENQ.REQ.RESP



    EB.DataAccess.FRead(FN.IVR,Y.ID,R.IVR, F.IVR, ER.IVR)


    Y.REQ = R.IVR<IRV.ENQ.OFS.REQUEST>
    Y.OFS.SOURCE.ID = "IVRPROC"
    THE.RESPONSE = ''
    TXN.COMMITED = ''
    EB.Interface.OfsCallBulkManager(Y.OFS.SOURCE.ID, Y.REQ, THE.RESPONSE, TXN.COMMITED)


    R.IVR<IRV.ENQ.OFS.RESPONSE> = THE.RESPONSE

    EB.DataAccess.FWrite(FN.IVR, Y.ID, R.IVR)

    RETURN
END
