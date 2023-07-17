* @ValidationCode : MjoxOTgxMTA0MTUwOkNwMTI1MjoxNjgxMTMyNzcxMTUyOklUU1M6LTE6LTE6MTg3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 18:49:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 187
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE CREDIT.LIMIT.MAINTENANCE.VALIDATE
*-------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the CREDIT.LIMIT.MAINTENANCE table
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Y.HARISH
* PROGRAM NAME : CREDIT.LIMIT.MAINTENANCE
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 02.06.2010    Y.HARISH          ODR-2009-10-0578    INITIAL CREATION
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* ------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CREDIT.LIMIT.MAINTENANCE
    $INSERT I_F.TECHNICAL.RESERVES.MAINTENANCE

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
******
    FN.CREDIT.LIMIT.MAINTENANCE        = 'F.CREDIT.LIMIT.MAINTENANCE'
    F.CREDIT.LIMIT.MAINTENANCE         = ''
    CALL OPF(FN.CREDIT.LIMIT.MAINTENANCE,F.CREDIT.LIMIT.MAINTENANCE)

    FN.TECHNICAL.RESERVES.MAINTENANCE  = 'F.TECHNICAL.RESERVES.MAINTENANCE'
    F.TECHNICAL.RESERVES.MAINTENANCE   = ''
    CALL OPF(FN.TECHNICAL.RESERVES.MAINTENANCE,F.TECHNICAL.RESERVES.MAINTENANCE)
    CALL CACHE.READ(FN.TECHNICAL.RESERVES.MAINTENANCE,'SYSTEM',R.TEC.RES,Y.ERR)
RETURN

PROCESS:
*********

    IF R.TEC.RES THEN
        Y.TECH.RES    = R.TEC.RES<TECH.RES.TECHNICAL.RESERVES>
    END
    Y.PER.ALLOWED = R.NEW(CRD.LIM.ALLOWED.PERCENTAGE)
    Y.TYPE.OF.GRP = R.NEW(CRD.LIM.TYPE.OF.GROUP)
    COUNT.PER = DCOUNT(Y.PER.ALLOWED,@VM)
    CNT = 1
    LOOP
    WHILE CNT LE COUNT.PER
        Y.PERCENT = Y.PER.ALLOWED<1,CNT>
        IF Y.PERCENT LE 100 THEN
            Y.TOT.AMT     = (Y.TECH.RES*Y.PERCENT)/100
            R.NEW(CRD.LIM.TOTAL.AMOUNT)<1,CNT>     = Y.TOT.AMT
            R.NEW(CRD.LIM.AVAILABLE.AMOUNT)<1,CNT> = Y.TOT.AMT - R.NEW(CRD.LIM.USED.AMOUNT)<1,CNT>
        END ELSE
            AF = CRD.LIM.ALLOWED.PERCENTAGE
            AV = CNT
            ETEXT = 'EB-ALLOWED.PERCENTAGE'
            CALL STORE.END.ERROR
        END
        CNT += 1
    REPEAT
RETURN
****************************************
END
