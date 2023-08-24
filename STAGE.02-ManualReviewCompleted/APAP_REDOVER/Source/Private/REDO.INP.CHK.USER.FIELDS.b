* @ValidationCode : Mjo2NzAwNTEzMjk6Q3AxMjUyOjE2ODI0MTIzMzA4NDI6SGFyaXNodmlrcmFtQzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CHK.USER.FIELDS
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.INP.CHK.USER.FIELDS
*Reference Number  :PACS00034123
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to check if the L.US.IDC.CODE & L.US.IDC.BR field contains value
*----------------------------------------------------------------------------------

*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 FM to @FM, VM to @VM, SM to @SM
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------------
INIT:
*~~~~
    LR.APP = 'USER'
    LR.FIELDS = 'L.US.IDC.CODE':@VM:'L.US.IDC.BR'
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FIELDS,LR.POS)

    L.US.IDC.CODE.POS = LR.POS<1,1>
    L.US.IDC.BR.POS = LR.POS<1,2>
RETURN
*----------------------------------------------------------------------------------
PROCESS:
*~~~~~~~
    IF V$FUNCTION EQ 'A' OR V$FUNCTION EQ 'R' THEN
        USR.IDC.CODES = R.USER<EB.USE.LOCAL.REF,L.US.IDC.CODE.POS>
        USR.IDC.BRS = R.USER<EB.USE.LOCAL.REF,L.US.IDC.BR.POS>
        CHANGE @SM TO @FM IN USR.IDC.CODES
        CHANGE @SM TO @FM IN USR.IDC.BRS
        USR.BRANCH = R.USER<EB.USE.CO.CODE>
        LOCATE USR.BRANCH IN USR.IDC.BRS SETTING BR.POS THEN
            USR.IDC.CODE = USR.IDC.CODES<BR.POS>
            IF NOT(USR.IDC.CODE) THEN
                E = "EB-USR.IDC.NOT.FOUND"
            END
        END ELSE
            E = "EB-USR.IDC.BR.NOT.FOUND"
        END
    END
RETURN
*----------------------------------------------------------------------------------
END
