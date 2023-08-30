* @ValidationCode : MjoxNjE3ODg1ODgwOkNwMTI1MjoxNjgxMTM1MTYzMzQxOklUU1M6LTE6LTE6MzU0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 354
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.STATUS.CANCEL
*
* ====================================================================================
*    - Set a Collateral rigth status Value refering to STATUS Core field
* ====================================================================================
*
* Subroutine Type : AUTH Routine
* Attached to     : Collateral.Right Versions
* Attached as     : AUTH Routine
* Primary Purpose :
*
*
* Incoming:
* ---------
* Outgoing:

*-----------------------------------------------------------------------------------
* Modification History:
* Development for : Asociacion Popular de ahorros y Prestamos
* Development by  : MG
* Date            : 18 OCT 2013
* CHANGE STATUS TO CANCELADO
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL.RIGHT
    $INSERT I_AA.LOCAL.COMMON ;*
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS ;*

*************************************************************************
*
*
    GOSUB INITIALISE
    GOSUB GET.LOCAL.FLDS.POS  ;
    GOSUB OPEN.FILES          ;
    GOSUB PROCESS     ;*PACS00324517

*
RETURN
*
* =========
INITIALISE:
* =========
*
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    R.CUSTOMER.ACCOUNT = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    R.AA.ACCOUNT.DETAILS = ''

    FN.AA.ARR.LIMIT = 'F.AA.ARR.LIMIT'
    F.AA.ARR.LIMIT  = ''
*

*Id Collateral.Rihgt
    Y.ID.COLLATERAL = ID.NEW : ".1"
    Y.LIM.REF.COUNT = ''
    Y.LIM.REF = ''
    Y.ID.CUSTOMER = ''
    Y.ID.LIMIT = ''
    NUM.AA.ID = 0
    NEW.LIMIT.REF = R.NEW(COLL.RIGHT.LIMIT.REFERENCE)
    OLD.LIMIT.REF = R.OLD(COLL.RIGHT.LIMIT.REFERENCE)
*

*
RETURN
*
*==================
GET.LOCAL.FLDS.POS:
*==================
* get local fields position from COLLATERAL.RIGHT
    Y.FIELD.CR  = "L.CR.ESTADO"
    Y.FIELD.NAME = Y.FIELD.CR
    Y.APPLICATION = "COLLATERAL.RIGHT"
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELD.NAME,Y.POS)
    Y.POS.STAT = Y.POS<1,1>
*
RETURN
*
*==========
OPEN.FILES:
*==========
*
    CALL OPF(FN.AA.ARR.LIMIT, F.AA.ARR.LIMIT)
    CALL OPF(FN.AA.ACCOUNT.DETAILS, F.AA.ACCOUNT.DETAILS)
    CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
RETURN
*
* ======
PROCESS:
* ======
    R.NEW(COLL.RIGHT.STATUS) = 'LIQ'      ;*** Collateral Right Status
    R.NEW(COLL.RIGHT.LOCAL.REF)<1,Y.POS.STAT> = 'LIQ'
*
RETURN
*

END
