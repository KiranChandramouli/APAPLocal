* @ValidationCode : MjoyNDU3NjM4OTpDcDEyNTI6MTY4MjQxMjM2MzU2NTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.PFC.VALUE.DATE
*-----------------------------------------------------------------------------
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : TAM
* Program Name : REDO.V.VAL.PFC.VALUE.DATE
*---------------------------------------------------------
* Description : This subroutine is attached input routine in REDO.AA.PART.DISBURSE.FC,PART.DISB
*
*----------------------------------------------------------
* Linked TO :
*----------------------------------------------------------
* Modification History:
* 28-11-2012          MARIMUTHU S            PACS00236823
*----------------------------------------------------------

*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT


    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.VAL.DATE = COMI

    Y.AA.ID = R.NEW(REDO.PDIS.ID.ARRANGEMENT)
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.REC,F.AA.ARRANGEMENT,AA.ARR.ERR)
    IF NOT(R.AA.REC) THEN
        CALL F.READ(FN.ACCOUNT,Y.AA.ID,R.ACC,F.ACCOUNT,ACC.ERR)
        IF R.ACC THEN
            Y.AA.ID = R.ACC<AC.ARRANGEMENT.ID>
            CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.REC,F.AA.ARRANGEMENT,AA.ARR.ERR)
            Y.EFF.DATE = R.AA.REC<AA.ARR.START.DATE>
        END
    END ELSE
        Y.EFF.DATE = R.AA.REC<AA.ARR.START.DATE>
    END

    IF Y.VAL.DATE LT Y.EFF.DATE THEN
        AF = REDO.PDIS.VALUE.DATE
        ETEXT = 'EB-DATE.CANNOT.EXCEED.VAL.DATE'
        CALL STORE.END.ERROR
    END

RETURN

END
