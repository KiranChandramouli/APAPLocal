$PACKAGE APAP.LAPAP
* @ValidationCode : MjotMTIyMzAxMzM4NDpDcDEyNTI6MTY4MjMzMTMyMDUxNjpJVFNTOi0xOi0xOjYwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 600
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

SUBROUTINE L.APAP.CORR.CASTIG.SEQPROT.POST
*
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to adjust the Insurance (SEGPROTFIN1) amount for the castigado prestamos.
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES


    FN.SAVE.LST = '&SAVEDLISTS&'
    F.SAVE.LST = ''
    CALL OPF(FN.SAVE.LST,F.SAVE.LST)

    C.TABLE.ID = "CASTIGADO_SEGPROTFIN1.PRESTAMOS.txt"
    YGRP.ARR = "ARRANGEMENT.ID,BILL.ID,SEGPROTFIN1 AMOUNT"
    SAVE.ERR = ''; R.SAVE.LST = ''
    CALL F.READ(FN.SAVE.LST,C.TABLE.ID,R.SAVE.LST,F.SAVE.LST,SAVE.ERR)
    IF R.SAVE.LST THEN
        DELETE F.SAVE.LST,C.TABLE.ID
    END

    SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT ":FN.SAVE.LST:" LIKE AK_CASTIGADO..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.REC,SEL.ERR)
    LOOP
        REMOVE SEL.ID FROM SEL.LIST SETTING SL.POSN
    WHILE SEL.ID:SL.POSN
        SAVE.ERR = ''; R.SAVE.LST = ''
        CALL F.READ(FN.SAVE.LST,SEL.ID,R.SAVE.LST,F.SAVE.LST,SAVE.ERR)
        DELETE F.SAVE.LST,SEL.ID
        YGRP.ARR<-1> = R.SAVE.LST
    REPEAT

    WRITE YGRP.ARR ON F.SAVE.LST,C.TABLE.ID

RETURN
END
