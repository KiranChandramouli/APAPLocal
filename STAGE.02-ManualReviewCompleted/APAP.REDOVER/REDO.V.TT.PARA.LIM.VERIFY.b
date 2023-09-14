* @ValidationCode : MjoxNzA2OTA3NzMxOkNwMTI1MjoxNjgxMzcxMjQ2MjU3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:04:06
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
SUBROUTINE REDO.V.TT.PARA.LIM.VERIFY
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.V.TT.PARA.LIM.VERIFY table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MUDASSIR
* PROGRAM NAME : REDO.V.PARA.LIM.VERIFY
*-----------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      SM TO @SM VM TO @VM,++ TO +=1
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN


INIT:
    LOC.REF.APPLICATION = 'TELLER.PARAMETER'
    ARR.TT.DESIGN = ''
    L.TT.LIMIT.C = ''
    CNT.LOOP = ''
    CNCT.ARR = ''
    ARR.VAL = ''
    LOC.REF.FIELDS = 'L.TT.DESGN':@VM:'L.TT.LIMIT.CCY'
    LOC.REF.POS = ''
RETURN


PROCESS:

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    L.TT.DESGN.POS = LOC.REF.POS<1,1>
    L.TT.LIMIT.POS =     LOC.REF.POS<1,2>
    ARR.TT.DESIGN= R.NEW(TT.PAR.LOCAL.REF)<1,L.TT.DESGN.POS>
    L.TT.LIMIT.C= R.NEW(TT.PAR.LOCAL.REF)<1,L.TT.LIMIT.POS>
    CNT.LOOP=DCOUNT(L.TT.LIMIT.C,@SM)
    Y.VAR =1
    LOOP
    WHILE Y.VAR LE CNT.LOOP
        TT.DESIGN=ARR.TT.DESIGN<1,1,Y.VAR>
        TT.LIMIT=L.TT.LIMIT.C<1,1,Y.VAR>
        ARR.VAL= TT.DESIGN:@VM:TT.LIMIT
        LOCATE ARR.VAL IN CNCT.ARR<1> SETTING POS THEN
            AF=TT.PAR.LOCAL.REF
            AV=L.TT.DESGN.POS
            AS=Y.VAR
            ETEXT = 'DUPLICATE TT DESIGN AND CURRENCY'
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            CNCT.ARR<-1>= ARR.VAL

        END
        Y.VAR += 1
    REPEAT
RETURN
END
