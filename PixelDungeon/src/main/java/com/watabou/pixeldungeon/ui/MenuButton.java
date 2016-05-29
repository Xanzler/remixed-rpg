package com.watabou.pixeldungeon.ui;

import com.nyrds.android.util.TrackedRuntimeException;
import com.watabou.noosa.Image;
import com.watabou.noosa.audio.Sample;
import com.watabou.noosa.ui.Button;
import com.watabou.pixeldungeon.Assets;
import com.watabou.pixeldungeon.scenes.GameScene;

/**
 * Created by mike on 30.05.2016.
 */
class MenuButton extends Button {

	private Image image;
	private Class<? extends Window> wndClass;

	public MenuButton(Image _image, Class<? extends Window> _wndClass ) {
		super();

		image = _image;
		wndClass = _wndClass;

		add(image);

		width = image.width + 4;
		height = image.height + 4;
	}

	@Override
	protected void layout() {
		super.layout();

		image.x = x + 2;
		image.y = y + 2;
	}

	@Override
	protected void onTouchDown() {
		image.brightness(1.5f);
		Sample.INSTANCE.play(Assets.SND_CLICK);
	}

	@Override
	protected void onTouchUp() {
		image.resetColor();
	}

	@Override
	protected void onClick() {
		try {
			GameScene.show(wndClass.newInstance());
		} catch (Exception e) {
			throw new TrackedRuntimeException(e);
		}
	}
}
