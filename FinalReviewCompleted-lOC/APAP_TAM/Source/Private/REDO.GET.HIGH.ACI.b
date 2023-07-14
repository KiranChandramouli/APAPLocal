* @ValidationCode : MjotNzcyMjA1Mjk0OkNwMTI1MjoxNjgzODkyNjI1MjA1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:05
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.HIGH.ACI(ACI.ID,Y.CUR,Y.RATE)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.GET.HIGH.ACI
*--------------------------------------------------------------------------------
* Description: This is a call routine to get the highest rate of ACI record.
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 31-May-2011    H GANESH       PACS00072194      INITIAL CREATION
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            ++ TO +=, FM TO @FM, VM TO @VM
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CREDIT.INT


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.RATE=0
    Y.TOTAL.BASIC=''
    FN.ACI='F.ACCOUNT.CREDIT.INT'
    F.ACI=''
    CALL OPF(FN.ACI,F.ACI)

    CALL F.READ(FN.ACI,ACI.ID,R.ACI,F.ACI,ACI.ERR)
    IF SUM(R.ACI<IC.ACI.CR.BASIC.RATE>) THEN
        GOSUB CHECK.BASIC.RATE
    END
    Y.INT.IDS=R.ACI<IC.ACI.CR.INT.RATE>
    CHANGE @VM TO @FM IN Y.INT.IDS
    Y.FINAL.IDS=Y.TOTAL.BASIC:@FM:Y.INT.IDS
    Y.RATE=MAXIMUM(Y.FINAL.IDS)

RETURN
*---------------------------------------------------------------------------------
CHECK.BASIC.RATE:
*---------------------------------------------------------------------------------
    Y.BASIC.IDS=R.ACI<IC.ACI.CR.BASIC.RATE>
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
