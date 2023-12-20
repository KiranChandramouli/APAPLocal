* @ValidationCode : MjoxMjYyMzc4MTE1OkNwMTI1MjoxNjgxODI4MDA0MzYxOklUU1M6LTE6LTE6MzAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.GENERATION.PROCESS


*DESCRIPTIONS:
*-------------
* This is  input routine of REDO.CARD.GENERATION to update the REDO.CARD.REQUEST with CARD GENERATION REQUEST RAISED
* It contains the table definitions
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*

* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                    Reference             Description
*  21 Apr 2011   Balagurunathan            PACS00052986          TO update REDO.CARD.REQUEST with value Yes in SENT.CRD.GEN.REQ
* 11-04-2023     CONVERSION TOOL           AUTO R22 CODE CONVERSION              NO CHANGES
* 11-04-2023     jayasurya H               MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REQUEST

    FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST=''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    CALL F.READ(FN.REDO.CARD.REQUEST,ID.NEW,R.REDO.CARD.REQUEST,FN.REDO.CARD.REQUEST,ERR)

    R.REDO.CARD.REQUEST<REDO.CARD.REQ.SENT.CRD.GEN.REQ>='YES'

    CALL F.WRITE(FN.REDO.CARD.REQUEST,ID.NEW,R.REDO.CARD.REQUEST)

RETURN

END
