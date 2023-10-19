* @ValidationCode : MjoxMTE4MDMwNjM6Q3AxMjUyOjE2ODA3NzMyOTg5MjU6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:58:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CRM.DOCUMENTATION.PROCESS(Y.REQ.ID)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.DOCUMENTATION.PROCESS
*--------------------------------------------------------------------------------
* Description:  This is batch routine to mark the REDO.FRONT.REQUEST records with
* status as pending document after the calendar days defined in param table.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE                DESCRIPTION
*  24-May-2011   H GANESH       PACS00071941             INITIAL CREATION
*
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.FRONT.REQUESTS
    $INSERT I_F.REDO.FRONT.CLAIMS
    $INSERT I_REDO.CRM.DOCUMENTATION.PROCESS.COMMON
 
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    V.WORK.FILE.LIST = CONTROL.LIST<1,1>
    IF V.WORK.FILE.LIST EQ 'REQUEST' THEN
        CALL F.READ(FN.REDO.FRONT.REQUESTS,Y.REQ.ID,R.REDO.FRONT.REQUESTS,F.REDO.FRONT.REQUESTS,FR.REQ.ERR)
        R.REDO.FRONT.REQUESTS<FR.CM.CLOSING.STATUS>='PENDING-DOCUMENTATION'
        R.REDO.FRONT.REQUESTS<FR.CM.STATUS>='CLOSED'
        R.REDO.FRONT.REQUESTS<FR.CM.CLOSING.DATE>=TODAY
        CALL F.WRITE(FN.REDO.FRONT.REQUESTS,Y.REQ.ID,R.REDO.FRONT.REQUESTS)
    END

    IF V.WORK.FILE.LIST EQ 'CLAIMS' THEN
        CALL F.READ(FN.REDO.FRONT.CLAIMS,Y.REQ.ID,R.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS,FR.CL.ERR)
        R.REDO.FRONT.REQUESTS<FR.CL.CLOSING.STATUS>='PENDING-DOCUMENTATION'
        R.REDO.FRONT.REQUESTS<FR.CL.STATUS>='CLOSED'
        R.REDO.FRONT.REQUESTS<FR.CL.CLOSING.DATE>=TODAY
        CALL F.WRITE(FN.REDO.FRONT.CLAIMS,Y.REQ.ID,R.REDO.FRONT.CLAIMS)
    END


RETURN
END
