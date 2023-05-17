SUBROUTINE REDO.V.VAL.REQ.SUBM.SAP
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS
*----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.ORDER.DETAIL,ITEM.REQUEST as
* a auth routine
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.V.VAL.REQ.SUBM.SAP
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010     JEEVA T        FIX FOR ISSUE HD1053868     INTIAL CREATION
* ------------------------------------------------------------------------
*----------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------

RETURN
PROCESS:
*---------------------------------------------------------
    R.NEW(RE.ORD.ORDER.STATUS) = "Orden Sometida a SAP"
RETURN
END
