SUBROUTINE REDO.CH.RESET.PIN
**
* Subroutine Type : VERSION
* Attached to     : REDO.CH.PINADM,RESET.PIN
* Attached as     : INPUT.ROUTINE for new content in PIN field
* Primary Purpose : Generate a new temporal PIN number for Telephone Channel
*     User
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version
*           ODR Reference: ODR-2010-06-0155
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Roberto Mondragon - TAM Latin America
*           rmondragon@temenos.com
*
*  5/12/11 - Update to key for PIN encryption
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*
*  5/12/11 - Update to key for PIN encryption
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*
*  8/01/13 - Update to COMMON file
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CH.PINADM
    $INSERT I_REDO.CH.V.USERPINCHG.COMMON

*PIN Generation
*    PINMAIL = RND(9) : RND(9) : RND(9) : RND(9)
*    PIN = PINMAIL
*    PIN.AS = PIN

*PIN Encription
*    KEYUSED = "7"
*    PIN = ENCRYPT(PIN,KEYUSED,JBASE_CRYPT_3DES)
*    PIN = ENCRYPT(PIN,KEYUSED,2)

*    R.NEW(REDO.CH.PINADMIN.PIN) = PIN

    R.NEW(REDO.CH.PINADMIN.START.DATE) = TODAY
    R.NEW(REDO.CH.PINADMIN.START.TIME) = FIELD(TIMEDATE()," ",0)
    R.NEW(REDO.CH.PINADMIN.TYPE) = "TEMPORAL"

RETURN

END
