SUBROUTINE REDO.V.VAL.ADD.CON
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ADD.CON
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.ADD.THIRDPARTY

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*---------
OPEN.PARA:
*---------
    FN.CUS.CON.LIST = 'F.CUS.CON.LIST'
    F.CUS.CON.LIST  = ''
    CALL OPF(FN.CUS.CON.LIST,F.CUS.CON.LIST)
    FN.REDO.ADD.THIRDPARTY = 'F.REDO.ADD.THIRDPARTY'
    F.REDO.ADD.THIRDPARTY  = ''
    CALL OPF(FN.REDO.ADD.THIRDPARTY,F.REDO.ADD.THIRDPARTY)

RETURN

*------------
PROCESS.PARA:
*------------
    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUSTOMER.ID = ""
    END
    GOSUB CHECK.EXISTING.CON

RETURN

*------------------
CHECK.EXISTING.CON:
*------------------
    Y.SERV.NAME = R.NEW(ARC.TP.COMP.SERV.NAME)
    Y.CONTRACT.NO = R.NEW(ARC.TP.CONTRACT.NO)
    CUS.CON.LIST.ID = CUSTOMER.ID
    CALL F.READ(FN.CUS.CON.LIST,CUS.CON.LIST.ID,R.CUS.CON.LIST,F.CUS.CON.LIST,CUS.CON.LIST.ER)
    IF CUS.CON.LIST.ER THEN
        RETURN
    END
    IF NOT(CUS.CON.LIST.ER) THEN

        LOOP

            REMOVE Y.TP.ID FROM R.CUS.CON.LIST SETTING Y.TP.POS
        WHILE Y.TP.ID:Y.TP.POS
            Y.ID = FIELD(Y.TP.ID,"*",1)
            CALL F.READ(FN.REDO.ADD.THIRDPARTY,Y.ID,R.REDO.ADD.THIRDPARTY,F.REDO.ADD.THIRDPARTY,REDO.ADD.THIRDPARTY.ERR)
            Y.TP.SERV.NAME = R.REDO.ADD.THIRDPARTY<ARC.TP.COMP.SERV.NAME>
            Y.TP.CONTRACT.NO = R.REDO.ADD.THIRDPARTY<ARC.TP.CONTRACT.NO>
            IF Y.TP.SERV.NAME EQ Y.SERV.NAME AND Y.CONTRACT.NO EQ Y.TP.CONTRACT.NO THEN

                AF = ARC.TP.CONTRACT.NO
                ETEXT = 'EB-EXISTING.CON'
                CALL STORE.END.ERROR
            END
        REPEAT
    END

RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------