* @ValidationCode : MjoxODY0MTU3OTk1OkNwMTI1MjoxNjgxMzc0NjYxNzI5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:01:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.COMP.NAME
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type : Validation
* Attached to     : APAP.H.INSURANCE.DETAILS,REDO.INGRESO
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            : 2011-05-17
*=======================================================================
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                       VM TO @VM,I TO I.VAR
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.REDO.APAP.H.COMP.NAME

*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

*
RETURN
*
* ======
PROCESS:
* ======

    CALL F.READ(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME, F.COMP.NAME, Y.ERR.COMP.NAME)

    FIELDS.NO = DCOUNT(R.COMP.NAME<REDO.CMP.CLASS.POLICY>,@VM)

    W.CLASS.POLICY = R.COMP.NAME<REDO.CMP.CLASS.POLICY>
    W.POLICY.TYPE = R.COMP.NAME<REDO.CMP.INS.POLICY.TYPE>

    FOR I.VAR=1 TO FIELDS.NO
        IF W.POLICY.TYPE<1,I.VAR> EQ Y.POLICY.TYPE AND W.CLASS.POLICY<1,I.VAR> EQ Y.CLASS.POLICY THEN
            R.NEW(INS.DET.SEN.POLICY.NUMBER) = R.COMP.NAME<REDO.CMP.SEN.POLICY.NUMBER,I.VAR>
            R.NEW(INS.DET.POLICY.NUMBER) = ''
        END
    NEXT I.VAR



RETURN
*
* =========
OPEN.FILES:
* =========
*

    CALL OPF(FN.COMP.NAME, F.COMP.NAME)

RETURN

*
* ======================
INITIALISE:
* ======================
*
    FN.COMP.NAME = 'F.REDO.APAP.H.COMP.NAME'
    F.COMP.NAME = ''
    R.COMP.NAME = ''
    Y.COMP.NAME.ID = COMI
    Y.ERR.COMP.NAME = ''

    Y.POLICY.TYPE = R.NEW(INS.DET.INS.POLICY.TYPE)
    Y.CLASS.POLICY = R.NEW(INS.DET.CLASS.POLICY)


RETURN

END
