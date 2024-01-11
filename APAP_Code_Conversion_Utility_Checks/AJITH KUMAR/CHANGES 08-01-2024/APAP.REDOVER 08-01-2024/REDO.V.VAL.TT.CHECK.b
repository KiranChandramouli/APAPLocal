* @ValidationCode : MjotMTUwMzA0MTQwOTpDcDEyNTI6MTY4MjQxMjM2NTYxNTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.TT.CHECK
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :GANESH.R
*Program Name :REDO.V.VAL.TT.CHECK
*---------------------------------------------------------------------------------

*DESCRIPTION :This program is used to make the local field mandatory based on below check
*
*LINKED WITH :
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     VM TO @VM
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
   $USING EB.LocalReferences
    GOSUB INIT
    GOSUB PROCESS
RETURN

*----*
INIT:
*----*
    LOC.REF.APPLICATION='USER'
    LOC.REF.FIELDS='L.US.CASIER.ROL'
    LOC.REF.POS=''
*    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
EB.LocalReferences.GetLocRef(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS);* R22 UTILITY AUTO CONVERSION
RETURN

*------*
PROCESS:
*------*

    L.US.CASH.ROLE=LOC.REF.POS<1,1>
    CASHIER.ROLE=R.NEW(EB.USE.LOCAL.REF)<1,L.US.CASH.ROLE>
    COMP.RESTR=R.NEW(EB.USE.COMPANY.RESTR)
    VCOUNT=DCOUNT(COMP.RESTR,@VM)
    FOR I.VAR = 1 TO VCOUNT ;*R22 Auto code conversion
        COMPANY.REST = R.NEW(EB.USE.COMPANY.RESTR)<1,I.VAR> ;*R22 Auto code conversion
        IF COMPANY.REST EQ 'ALL' OR COMPANY.REST EQ ID.COMPANY THEN
            APPLN=R.NEW(EB.USE.APPLICATION)<1,I.VAR> ;*R22 Auto code conversion
            IF APPLN EQ 'ALL.PG' OR APPLN EQ 'TELLER' THEN
                GOSUB CHECK:
            END
        END
    NEXT I.VAR ;*R22 Auto code conversion
RETURN

*----*
CHECK:
*-----*
    IF CASHIER.ROLE EQ '' THEN
        AF=EB.USE.LOCAL.REF
        AV=L.US.CASH.ROLE
        ETEXT='EB-INPUT.MISSING'
        CALL STORE.END.ERROR
    END
RETURN
*---------*

END
