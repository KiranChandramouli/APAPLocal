* @ValidationCode : MjotNzg2MDEzODMxOkNwMTI1MjoxNjk5MzYzNDMwNDc3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Nov 2023 18:53:50
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
    SUBROUTINE REDO.B.IVR.ENQ.REQUEST(Y.ID)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*DATE          AUTHOR                   Modification                            DESCRIPTION
*07/10/2023   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES            NOCHANGES
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
