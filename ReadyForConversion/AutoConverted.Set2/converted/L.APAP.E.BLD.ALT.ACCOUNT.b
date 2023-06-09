SUBROUTINE L.APAP.E.BLD.ALT.ACCOUNT(ENQ.DATA)
*
* Description: The routine to get the actual Account number for the Alternative ID.
* Dev By: Ashokkumar
*
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ALTERNATE.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'; F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)
RETURN

PROCESS:
********
    LOCATE "ARRANGEMENT.ID" IN ENQ.DATA<2,1> SETTING SYSD.POS THEN
        YALTER.ID = ENQ.DATA<4,SYSD.POS>
        IF YALTER.ID NE '' THEN
            R.ALT.AC = ''; ALT.AC.ERR = ''
            CALL F.READ(FN.ALTERNATE.ACCOUNT,YALTER.ID,R.ALT.AC,F.ALTERNATE.ACCOUNT,ALT.AC.ERR)
            IF R.ALT.AC THEN
                YALTER.ID = R.ALT.AC<AAC.GLOBUS.ACCT.NUMBER>
            END
        END
        ENQ.DATA<3,SYSD.POS> = "EQ"
        ENQ.DATA<4,SYSD.POS> = YALTER.ID
    END
RETURN

END
