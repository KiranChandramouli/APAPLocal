* @ValidationCode : MjoxNTAzMDU1NDc4OkNwMTI1MjoxNjgxMTEyNTA4ODQ3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:11:48
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
SUBROUTINE REDO.GET.HIGH.GCI(GCI.ID,Y.CUR,Y.RATE)

*--------------------------------------------------------------------------------
* Company Name : ASOCIGCION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.GET.HIGH.GCI
*--------------------------------------------------------------------------------
* Description: This is a call routine to get the highest rate of GCI record.
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 31-May-2011    H GANESH       PACS00072194      INITIAL CREATION
*
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            F.READ TO CACHE.READ,FM TO @FM, VM TO @VM, ++ TO +=
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.GROUP.CREDIT.INT


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.RATE=0
    Y.TOTAL.BASIC=''
    FN.GCI='F.GROUP.CREDIT.INT'
    F.GCI=''
    CALL OPF(FN.GCI,F.GCI)

    CALL CACHE.READ(FN.GCI, GCI.ID, R.GCI, GCI.ERR) ;*AUTO R22 CODE CONVERSION
    IF SUM(R.GCI<IC.GCI.CR.BASIC.RATE>) THEN
        GOSUB CHECK.BASIC.RATE
    END
    Y.INT.IDS=R.GCI<IC.GCI.CR.INT.RATE>
    CHANGE @VM TO @FM IN Y.INT.IDS
    Y.FINAL.IDS=Y.TOTAL.BASIC:@FM:Y.INT.IDS
    Y.RATE=MAXIMUM(Y.FINAL.IDS)

RETURN
*---------------------------------------------------------------------------------
CHECK.BASIC.RATE:
*---------------------------------------------------------------------------------
    Y.BASIC.IDS=R.GCI<IC.GCI.CR.BASIC.RATE>
    Y.BASIC.ID.CNT=DCOUNT(Y.BASIC.IDS,@VM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.BASIC.ID.CNT
        IF Y.BASIC.IDS<1,Y.VAR1> THEN
            Y.BASIC.AND.CURR=Y.BASIC.IDS<1,Y.VAR1>:Y.CUR:TODAY
            CALL EB.GET.INTEREST.RATE(Y.BASIC.AND.CURR, BASIC.INT.RATE)
            Y.TOTAL.BASIC<-1>=BASIC.INT.RATE
        END
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN
END
