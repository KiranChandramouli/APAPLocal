* @ValidationCode : MjotMTc2MjY4MjA4MjpDcDEyNTI6MTcwNDg4NjM4MDcyOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Jan 2024 17:03:00
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
SUBROUTINE REDO.R.CRE.ARR.LIMIT.SEQ.UPD(P.CUSTOMER.ID, P.LIMIT.REF, P.ACTION, P.LAST.ID, P.LAST.COLL.ID)
*----------------------------------------------------------------------------------------------------
* DESCRIPTION :
*              This routine works over REDO.CRE.ARR.LIMIT.SEQ live.file. Allows to read, add or update an
*              entry from that live file
*
* This routine is going to be used on REDO.CREATE.ARRANGEMENT application
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    :
*                   P.CUSTOMER.ID          Customer identifier
*                   P.LIMIT.REF            Limit Reference identifier
*                   P.ACTION               Action to be taken
*                                          (R)ead last used Sequence
*                                          (U)pdate or insert the last used Sequence
*                   P.LAST.ID              Last sequence used, this must be sent when P.ACTION = 'U'
*                   P.LAST.COLL.ID         Last sequence used for create a Collateral.Right, is optional
* OUT Parameter   :
*                   E                      is equals to "" then everything OK
*                   P.LAST.ID              When the P.ACTION = 'R',then it Sreturns the last sequence used for
*                                          the CUSTOMER.ID and the LIMIT.REFERENCE
*                                          If the references was not found then 00 is returned
*                   P.LAST.COLL.ID         When the P.ACTION = 'R' the is returns the last sequence used for
*                                          create the collateral.right for the current P.CUSTOMER.ID
*                                          If the references was not found then 0 is returned
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : hpasquel@temenos.com
* PROGRAM NAME : REDO.R.CRE.ARR.LIMIT.SEQ.UPD
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference         Description
* 05-Jan-2011    Paul Pasquel      ODR-2009-11-0199    Initial creation
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CRE.ARR.LIMIT.SEQ

    E = ""
    GOSUB VALIDATE.PARAMETERS
    IF E EQ "" THEN
        GOSUB OPEN.FILE
        GOSUB PROCESS
    END
RETURN
*------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------
    R.REDO.CRE.ARR.LIMIT.SEQ = ''
    YERR = ''
    R.REDO.CRE.ARR.LIMIT.SEQ = ''
*    CALL F.READ(FN.REDO.CRE.ARR.LIMIT.SEQ,P.CUSTOMER.ID,R.REDO.CRE.ARR.LIMIT.SEQ,F.REDO.CRE.ARR.LIMIT.SEQ,YERR)
    CALL F.READU(FN.REDO.CRE.ARR.LIMIT.SEQ,P.CUSTOMER.ID,R.REDO.CRE.ARR.LIMIT.SEQ,F.REDO.CRE.ARR.LIMIT.SEQ,YERR,'');* R22 UTILITY AUTO CONVERSION
*      IF R.REDO.CRE.ARR.LIMIT.SEQ EQ "" AND THEN
*         E = "ST-REDO.RECORD.NOT.FOUND" : VM : "RECORD ID & WAS NOT FOUND ON &"
*         E<2> = P.CUSTOMER.ID : VM : FN.REDO.CRE.ARR.LIMIT.SEQ
*         RETURN
*      END
    Y.POS = ''
    Y.LAST.ID = ''
    GOSUB SEARCH.LIMIT.REF
    BEGIN CASE
        CASE P.ACTION EQ "R"
            P.LAST.ID = Y.LAST.ID
            P.LAST.COLL.ID = R.REDO.CRE.ARR.LIMIT.SEQ<REDO.FC.LS.LAST.COL.RIG.ID>
            IF P.LAST.COLL.ID EQ '' THEN
                P.LAST.COLL.ID = 0
            END
        CASE P.ACTION EQ "U"
            P.LAST.ID = FMT(P.LAST.ID,"R%2")
            IF Y.POS EQ 0 THEN
                R.REDO.CRE.ARR.LIMIT.SEQ<REDO.FC.LS.LIMIT.REF,-1> = P.LIMIT.REF
                R.REDO.CRE.ARR.LIMIT.SEQ<REDO.FC.LS.LAST.ID,-1> = P.LAST.ID
            END ELSE
                R.REDO.CRE.ARR.LIMIT.SEQ<REDO.FC.LS.LAST.ID,Y.POS> = P.LAST.ID
            END
            IF P.LAST.COLL.ID NE '' THEN
                R.REDO.CRE.ARR.LIMIT.SEQ<REDO.FC.LS.LAST.COL.RIG.ID> = P.LAST.COLL.ID
            END
            CALL F.WRITE(FN.REDO.CRE.ARR.LIMIT.SEQ,P.CUSTOMER.ID,R.REDO.CRE.ARR.LIMIT.SEQ)
    END CASE
RETURN

*------------------------------------------------------------------------------------------------------
OPEN.FILE:
*------------------------------------------------------------------------------------------------------
    FN.REDO.CRE.ARR.LIMIT.SEQ = 'F.REDO.CRE.ARR.LIMIT.SEQ'
    F.REDO.CRE.ARR.LIMIT.SEQ = ''
    CALL OPF(FN.REDO.CRE.ARR.LIMIT.SEQ,F.REDO.CRE.ARR.LIMIT.SEQ)
RETURN
*------------------------------------------------------------------------------------------------------
SEARCH.LIMIT.REF:
*------------------------------------------------------------------------------------------------------
    Y.POS = ''
    LOCATE P.LIMIT.REF IN R.REDO.CRE.ARR.LIMIT.SEQ<REDO.FC.LS.LIMIT.REF,1> SETTING Y.POS THEN
        Y.LAST.ID = R.REDO.CRE.ARR.LIMIT.SEQ<REDO.FC.LS.LAST.ID,Y.POS>
    END ELSE
        Y.LAST.ID = "00"
        Y.POS = 0
    END
RETURN
*------------------------------------------------------------------------------------------------------
VALIDATE.PARAMETERS:
*------------------------------------------------------------------------------------------------------
    Y.RTN.NAME = "REDO.R.CRE.ARR.LIMIT.SEQ"
    Y.PAR.REQ.MSG = "ST-REDO.FC.PARAM.REQUIRED" : @VM : "PARAMETER & REQUIRED &"
* Parameter CUSTOMER.ID is required
    IF P.CUSTOMER.ID EQ "" THEN
        E = Y.PAR.REQ.MSG
        E<2> = "P.CUSTOMER.ID" : @VM : Y.RTN.NAME
    END
* Parameter P.LIMIT.REF is required
    IF P.LIMIT.REF EQ "" THEN
        E = Y.PAR.REQ.MSG
        E<2> = "P.LIMIT.REF" : @VM : Y.RTN.NAME
    END
* Parameter P.ACTION must be U or R
    IF NOT(P.ACTION MATCHES "U" : @VM : "R") THEN
        E = "ST-REDO.FC.INVALID.ARG" : @VM : "VALUE & IS NOT ALLOWED FOR PARAMETER &"
        E<2> = P.ACTION : @VM : "P.ACTION"
    END
* If parameter P.ACTION is equals to U then parameter P.LAST.ID is mandatory
    IF P.ACTION EQ "U" AND P.LAST.ID EQ "" THEN
        E = Y.PAR.REQ.MSG
        E<2> = "P.LAST.ID" : @VM : Y.RTN.NAME
    END

* LAST.COLL.ID is optional
* If parameter P.ACTION is equals to U then parameter P.LAST.COLL.ID is mandatory
*      IF P.ACTION EQ "U" AND P.LAST.COLL.ID EQ "" THEN
*         E = Y.PAR.REQ.MSG
*         E<2> = "P.LAST.COLL.ID" : VM : Y.RTN.NAME
*      END

RETURN
*------------------------------------------------------------------------------------------------------
END
